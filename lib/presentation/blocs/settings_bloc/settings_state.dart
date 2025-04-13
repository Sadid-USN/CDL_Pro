import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final AppDataType selectedType;
  final AppLanguage selectedLang;
  final int tapCount;
  final bool isExpanded;
  final LoadingStatus loadingStatus;
  final List<TestsDataModel> testsModel;
  // final List<ChaptersModel> likedChapters;
  final bool isDarkMode;

  final Stream<QuerySnapshot>? testsStream; // Новое поле для потока данных

  const SettingsState({
    required this.selectedType,
    required this.tapCount,
    required this.isExpanded,
    required this.loadingStatus,
    required this.testsModel,
    required this.selectedLang,
    // required this.likedChapters,
    required this.isDarkMode,
    this.testsStream, // Добавляем bookStream в конструктор
  });

  factory SettingsState.initial() {
    return const SettingsState(
      selectedLang: AppLanguage.english,
      selectedType: AppDataType.cdlTests,
      tapCount: 0,
      isExpanded: false,
      loadingStatus: LoadingStatus.completed,
      testsModel: [],
      // likedChapters: [],
      isDarkMode: false,

      testsStream: null, // Инициализируем как null
    );
  }

  SettingsState copyWith({
    AppDataType? selectedType,
    AppLanguage ? selectedLang,
    int? tapCount,
    bool? isExpanded,
    LoadingStatus? loadingStatus,
    List<TestsDataModel>? testsModel,
    // List<ChaptersModel>? likedChapters,
    bool? isDarkMode,
    Stream<QuerySnapshot>? testsStream, // Добавляем bookStream в copyWith
  }) {
    return SettingsState(
      selectedLang: selectedLang ?? this.selectedLang,
      selectedType: selectedType ?? this.selectedType,
      tapCount: tapCount ?? this.tapCount,
      isExpanded: isExpanded ?? this.isExpanded,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      testsModel: testsModel ?? this.testsModel,
      // likedChapters: likedChapters ?? this.likedChapters,
      isDarkMode: isDarkMode ?? this.isDarkMode,

      testsStream: testsStream ?? this.testsStream, // Обновляем bookStream
    );
  }

  @override
  List<Object?> get props => [
    selectedType,
    selectedLang,
    tapCount,
    loadingStatus,
    testsModel,
    // likedChapters,
    isExpanded,
    isDarkMode,
    testsStream,
  ];
}
