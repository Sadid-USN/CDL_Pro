import 'dart:async';
import 'dart:convert';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/presentation/blocs/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

class SettingsBloc extends Bloc<AbstractSettingsEvent, SettingsState> {
  final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
  late SharedPreferences prefs;

  SettingsBloc() : super(SettingsState.initial()) {
    on<InitializeSettings>(_onInitializeSettings);
    on<LoadSavedLanguage>(_onLoadSavedLanguage);
    on<ChangeLanguage>(onChangeLanguage);

    on<UploadData>(_onUploadData);
    on<IncrementTapCount>(_onIncrementTapCount);
    on<ChangeType>(_onChangeType);

    on<ChangeTheme>(_onChangeTheme);
    // on<InitializeRive>(_onInitializeRive);
    on<LoadData>(_onLoadDataType);
    add(InitializeSettings());
  }

  void _onChangeType(ChangeType event, Emitter<SettingsState> emit) async {
    // Update the selected type in state
    emit(state.copyWith(selectedType: event.newType));

    // Reload data for the new type
    add(const LoadData());
  }

  void _onLoadDataType(LoadData event, Emitter<SettingsState> emit) async {
    final testsStream = _getQuizCollection(state.selectedType).snapshots();
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(testsStream: testsStream));
  }

  void _onChangeTheme(ChangeTheme event, Emitter<SettingsState> emit) async {
    final newThemeMode = !state.isDarkMode; // Переключаем тему
    await prefs.setBool('themeMode', newThemeMode);

    emit(state.copyWith(isDarkMode: newThemeMode));

    print("UPDATE THEME --->> ${newThemeMode}");
  }

  void _onInitializeSettings(
    InitializeSettings event,
    Emitter<SettingsState> emit,
  ) async {
    prefs = await SharedPreferences.getInstance();

    // Загружаем сохраненную тему
    final savedThemeMode = prefs.getBool('themeMode') ?? false;

    // Загружаем сохраненный язык
    final savedLang = prefs.getString('selectedLang');
    final initialLanguage =
        savedLang != null ? _getLanguageEnum(savedLang) : AppLanguage.english;

    // Обновляем состояние с сохраненной темой и языком
    emit(
      state.copyWith(isDarkMode: savedThemeMode, selectedLang: initialLanguage),
    );

    // Инициируем загрузку книг при инициализации
    add(const LoadData());
  }

  /// ✅ Увеличение счётчика скрытых настроек
  void _onIncrementTapCount(
    IncrementTapCount event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(tapCount: state.tapCount + 1));
  }

  // ✅ Получение потока данных Firestore (для отображения в `StreamBuilder`)
  Stream<QuerySnapshot> getQuizStream() {
    return _getQuizCollection(state.selectedType).snapshots();
  }

  CollectionReference<Map<String, dynamic>> _getQuizCollection(
    AppDataType dataType,
  ) {
    String collectionName;

    if (dataType == AppDataType.cdlTests) {
      collectionName = 'CDLTests';
    } else if (dataType == AppDataType.roadSign) {
      collectionName = 'RoadSign';
    } else {
      collectionName = 'PreTripInseption';
    }

    return firebaseStore.collection(collectionName);
  }

  /// ✅ Загрузка сохранённого языка
  void _onLoadSavedLanguage(
    LoadSavedLanguage event,
    Emitter<SettingsState> emit,
  ) {
    String? savedLang = prefs.getString('selectedLang');
    if (savedLang != null) {
      AppLanguage selectedType = _getLanguageEnum(savedLang);
      emit(state.copyWith(selectedLang: selectedType));
    }
  }

  /// ✅ Изменение языка
  void onChangeLanguage(
    ChangeLanguage event,
    Emitter<SettingsState> emit,
  ) async {
    if (state.selectedLang == event.newLanguage) return;

    await prefs.setString('selectedLang', getLanguageCode(event.newLanguage));
    emit(state.copyWith(selectedLang: event.newLanguage));
    add(const LoadData());
  }

  Future<void> _onUploadData(
    UploadData event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(loadingStatus: LoadingStatus.loading));

    try {
      final quizCollection = _getQuizCollection(state.selectedType);
      final assetPath = _getAssetPath(state.selectedType);

      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      final quizFiles =
          manifestMap.keys
              .where(
                (path) => path.startsWith(assetPath) && path.endsWith('.json'),
              )
              .toList();

      if (quizFiles.isEmpty) {
        throw Exception("Нет JSON-файлов в assets");
      }

      var batch = firebaseStore.batch();
      for (var path in quizFiles) {
        final jsonString = await rootBundle.loadString(path);
        final Map<String, dynamic> jsonData = json.decode(jsonString);

        final docRef = quizCollection.doc(); 

        switch (state.selectedType) {
          case AppDataType.cdlTests:
            final quizData = TestsDataModel.fromJson(jsonData);
            batch.set(docRef, quizData.toJson());
            break;
          case AppDataType.roadSign:
            // Предполагаем, что файл содержит массив знаков
            final signsData = RoadSignListModel.fromJson(jsonData);
            for (var sign in signsData.signs) {
              final signDocRef =
                  quizCollection.doc(); // новый документ для каждого знака
              batch.set(signDocRef, sign.toJson());
            }
            break;
          case AppDataType.tripInseption:
            final inspectionData = PreTripInspectionListModel.fromJson(jsonData);
            batch.set(docRef, inspectionData.toJson());
            break;
        }
      }

      await batch.commit();
      emit(state.copyWith(loadingStatus: LoadingStatus.completed));
    } catch (error, stack) {
      GetIt.instance<Talker>().handle(error, stack);
      emit(state.copyWith(loadingStatus: LoadingStatus.error));
    }
  }

  String _getAssetPath(AppDataType dataType) {
    switch (dataType) {
      case AppDataType.cdlTests:
        return 'assets/DB/tests';
      case AppDataType.roadSign:
        return 'assets/DB/road_signs';
      case AppDataType.tripInseption:
        return 'assets/DB/trip_inspection';
    }
  }

  String getSelectetTypeName(AppDataType language) {
    switch (language) {
      case AppDataType.cdlTests:
        return 'CDL Tests';
      case AppDataType.tripInseption:
        return 'Pre Trip Inseption';

      case AppDataType.roadSign:
        return 'Road Sign';
    }
  }

  /// ✅ Получение `AppLanguage` по строковому коду
  AppLanguage _getLanguageEnum(String languageCode) {
    switch (languageCode) {
      case 'en':
        return AppLanguage.english;

      case 'ru':
        return AppLanguage.russian;
      case 'uk':
        return AppLanguage.ukrainian;
      default:
        return AppLanguage.english;
    }
  }

  static String getLanguageCode(AppLanguage language) {
    // Теперь статический
    switch (language) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.ukrainian:
        return 'uk';

      case AppLanguage.russian:
        return 'ru';
    }
  }
}
