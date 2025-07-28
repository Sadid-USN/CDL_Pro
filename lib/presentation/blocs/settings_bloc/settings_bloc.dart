import 'dart:async';
import 'dart:convert';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/presentation/blocs/settings_bloc/settings.dart';
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
    on<ChangeLanguage>(_onChangeLanguage);
    on<UploadData>(_onUploadData);
    on<IncrementTapCount>(_onIncrementTapCount);
    on<ChangeType>(_onChangeType);
    on<SetCollection>(_onSetCollection);
    on<ChangeTheme>(_onChangeTheme);
    on<LoadData>(_onLoadDataType);

    add(InitializeSettings());
  }

  Stream<QuerySnapshot>? get collection => state.collectionStream;
  String get currentLangCode => getLanguageCode(state.selectedLang);
  Future<void> saveCollectionToCache(
    String key,
    List<Map<String, dynamic>> data,
  ) async {
    final jsonString = jsonEncode(data);
    await prefs.setString(key, jsonString);
  }

  Future<List<Map<String, dynamic>>?> loadCollectionFromCache(
    String key,
  ) async {
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;

    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> _onSetCollection(
    SetCollection event,
    Emitter<SettingsState> emit,
  ) async {
    final stream = _getQuizCollection(event.collectionName).snapshots();
    emit(state.copyWith(collectionStream: stream));
  }

  void _onLoadDataType(LoadData event, Emitter<SettingsState> emit) {
    final testsStream = _getQuizCollection(state.selectedType).snapshots();
    emit(state.copyWith(collectionStream: testsStream));
  }

  void _onChangeType(ChangeType event, Emitter<SettingsState> emit) {
    emit(state.copyWith(selectedType: event.newType));
    add(const LoadData()); // This will trigger data loading for the new type
  }

  void _onChangeTheme(ChangeTheme event, Emitter<SettingsState> emit) async {
    final newThemeMode = !state.isDarkMode;
    await prefs.setBool('themeMode', newThemeMode);
    emit(state.copyWith(isDarkMode: newThemeMode));
 
  }

  void _onInitializeSettings(
    InitializeSettings event,
    Emitter<SettingsState> emit,
  ) async {
    prefs = await SharedPreferences.getInstance();

    final savedThemeMode = prefs.getBool('themeMode') ?? false;
    final savedLang = prefs.getString('selectedLang');
    final initialLanguage =
        savedLang != null ? _getLanguageEnum(savedLang) : AppLanguage.english;

    emit(
      state.copyWith(isDarkMode: savedThemeMode, selectedLang: initialLanguage),
    );

    add(const LoadData());
  }

  void _onIncrementTapCount(
    IncrementTapCount event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(tapCount: state.tapCount + 1));
  }

  Stream<QuerySnapshot> getQuizStream() =>
      _getQuizCollection(state.selectedType).snapshots();

  CollectionReference<Map<String, dynamic>> _getQuizCollection(
    AppDataType dataType,
  ) {
    switch (dataType) {
      case AppDataType.cdlTests:
        return firebaseStore.collection('CDLTests');
      case AppDataType.cdlTestsRu:
        return firebaseStore.collection('CDLTestsRu');
      case AppDataType.cdlTestsUk:
        return firebaseStore.collection('CDLTestsUk');
      case AppDataType.cdlTestsEs:
        return firebaseStore.collection('CDLTestsEs');
      case AppDataType.roadSign:
        return firebaseStore.collection('RoadSign');
      case AppDataType.tripInseption:
        return firebaseStore.collection('PreTripInseption');
      case AppDataType.termsOfUse:
        return firebaseStore.collection('termsOfUse');
      case AppDataType.privacyPolicy:
        return firebaseStore.collection('PrivacyPolicy');
    }
  }

  void _onLoadSavedLanguage(
    LoadSavedLanguage event,
    Emitter<SettingsState> emit,
  ) {
    final savedLang = prefs.getString('selectedLang');
    if (savedLang != null) {
      final selectedType = _getLanguageEnum(savedLang);
      emit(state.copyWith(selectedLang: selectedType));
    }
  }

  void _onChangeLanguage(
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
        throw Exception("Нет JSON-файлов в assets!!");
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
          case AppDataType.cdlTestsRu:
            final quizData = TestsDataModel.fromJson(jsonData);
            batch.set(docRef, quizData.toJson());
            break;
          case AppDataType.cdlTestsUk:
            final quizData = TestsDataModel.fromJson(jsonData);
            batch.set(docRef, quizData.toJson());
            break;
          case AppDataType.cdlTestsEs:
            final quizData = TestsDataModel.fromJson(jsonData);
            batch.set(docRef, quizData.toJson());
            break;
          case AppDataType.roadSign:
            final sign = RoadSignResponse.fromJson(jsonData);
            batch.set(docRef, sign.toJson());
            break;
          case AppDataType.tripInseption:
            final inspectionModel = PreTripInspectionListModel.fromJson(
              jsonData,
            );
            batch.set(docRef, inspectionModel.toJson());
            break;
          case AppDataType.termsOfUse:
            final terms = TermsOfUseModel.fromJson(jsonData);
            batch.set(docRef, terms.toJson());
            break;
          case AppDataType.privacyPolicy:
            final terms = PrivacyPolicyModel.fromJson(jsonData);
            batch.set(docRef, terms.toJson());
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
      case AppDataType.cdlTestsRu:
        return 'assets/DB/tests_ru';
      case AppDataType.cdlTestsUk:
        return 'assets/DB/tests_uk';
      case AppDataType.cdlTestsEs:
        return 'assets/DB/tests_es';
      case AppDataType.roadSign:
        return 'assets/DB/road_signs';
      case AppDataType.tripInseption:
        return 'assets/DB/trip_inspection';
      case AppDataType.termsOfUse:
        return 'assets/DB/terms_of_use';
      case AppDataType.privacyPolicy:
        return 'assets/DB/privacy_policy';
    }
  }

  /// Получение локализованного названия языка
  String getSelectedLangTitle(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.russian:
        return 'Русский';
      case AppLanguage.ukrainian:
        return 'Українська';
      case AppLanguage.spanish:
        return 'Español';
    }
  }

  /// Получение `AppLanguage` по коду
  AppLanguage _getLanguageEnum(String languageCode) {
    switch (languageCode) {
      case 'en':
        return AppLanguage.english;
      case 'ru':
        return AppLanguage.russian;
      case 'uk':
        return AppLanguage.ukrainian;
      case 'es':
        return AppLanguage.spanish;
      default:
        return AppLanguage.english;
    }
  }

  /// Получение строкового кода по языку
  static String getLanguageCode(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.ukrainian:
        return 'uk';
      case AppLanguage.russian:
        return 'ru';
      case AppLanguage.spanish:
        return 'es';
    }
  }
}

