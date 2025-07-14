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

  // Данные CDL-тестов
  final List<TestsDataModel> testsModel;

  final bool isDarkMode;

  const SettingsState({
    required this.collectionStream,
    required this.selectedType,
    required this.selectedLang,
    required this.tapCount,
    required this.isExpanded,
    required this.loadingStatus,
    required this.testsModel,

    required this.isDarkMode,
  });

  factory SettingsState.initial() {
    return const SettingsState(
      collectionStream: null,
      selectedType: AppDataType.cdlTests,
      selectedLang: AppLanguage.english,
      tapCount: 0,
      isExpanded: false,
      loadingStatus: LoadingStatus.completed,
      testsModel: [],

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

    bool? isDarkMode,
  }) {
    return SettingsState(
      collectionStream: collectionStream ?? this.collectionStream,
      selectedType: selectedType ?? this.selectedType,
      selectedLang: selectedLang ?? this.selectedLang,
      tapCount: tapCount ?? this.tapCount,
      isExpanded: isExpanded ?? this.isExpanded,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      testsModel: testsModel ?? this.testsModel,

      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  @override
  List<Object?> get props => [
    collectionStream,
    selectedType,
    selectedLang,
    tapCount,
    isExpanded,
    loadingStatus,
    testsModel,

    isDarkMode,
  ];
}
