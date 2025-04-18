import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final Stream<QuerySnapshot>? collectionStream;

  final AppDataType selectedType;
  final AppLanguage selectedLang;
  final int tapCount;
  final bool isExpanded;
  final LoadingStatus loadingStatus;
  final List<TestsDataModel> testsModel;
  // final List<ChaptersModel> likedChapters;
  final bool isDarkMode;

// Новое поле для потока данных

  const SettingsState({
    required this.collectionStream,
    required this.selectedType,
    required this.tapCount,
    required this.isExpanded,
    required this.loadingStatus,
    required this.testsModel,
    required this.selectedLang,
    // required this.likedChapters,
    required this.isDarkMode,
 // Добавляем bookStream в конструктор
  });

  factory SettingsState.initial() {
    return const SettingsState(
      collectionStream: null,
      selectedLang: AppLanguage.english,
      selectedType: AppDataType.cdlTests,
      tapCount: 0,
      isExpanded: false,
      loadingStatus: LoadingStatus.completed,
      testsModel: [],
      // likedChapters: [],
      isDarkMode: false,

      
    );
  }

  SettingsState copyWith({
    Stream<QuerySnapshot>? collectionStream,
    AppDataType? selectedType,
    AppLanguage? selectedLang,
    int? tapCount,
    bool? isExpanded,
    LoadingStatus? loadingStatus,
    List<TestsDataModel>? testsModel,
    // List<ChaptersModel>? likedChapters,
    bool? isDarkMode,
   // Добавляем bookStream в copyWith
  }) {
    return SettingsState(
      collectionStream: collectionStream ?? this.collectionStream,
      selectedLang: selectedLang ?? this.selectedLang,
      selectedType: selectedType ?? this.selectedType,
      tapCount: tapCount ?? this.tapCount,
      isExpanded: isExpanded ?? this.isExpanded,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      testsModel: testsModel ?? this.testsModel,
      // likedChapters: likedChapters ?? this.likedChapters,
      isDarkMode: isDarkMode ?? this.isDarkMode,

     // Обновляем bookStream
    );
  }

  @override
  List<Object?> get props => [
    collectionStream,
    selectedType,
    selectedLang,
    tapCount,
    loadingStatus,
    testsModel,
    // likedChapters,
    isExpanded,
    isDarkMode,
 
  ];
}
