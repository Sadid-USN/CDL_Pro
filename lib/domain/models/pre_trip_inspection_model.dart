import 'package:equatable/equatable.dart';


class PreTripInspectionListModel extends Equatable {
  final List<PreTripChapter> preTripInspection;

  const PreTripInspectionListModel({required this.preTripInspection});

  factory PreTripInspectionListModel.fromJson(Map<String, dynamic> json) {
    final list = json['pre_trip_inspection'] as List<dynamic>?;

    return PreTripInspectionListModel(
      preTripInspection: list != null
          ? list.map((x) => PreTripChapter.fromJson(x)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'pre_trip_inspection':
            preTripInspection.map((x) => x.toJson()).toList(),
      };

  @override
  List<Object?> get props => [preTripInspection];
}

class PreTripChapter extends Equatable {
  final int chapterId;
  final TitleBlock chapterTitle;
  final List<PreTripStep> steps;

  const PreTripChapter({
    required this.chapterId,
    required this.chapterTitle,
    required this.steps,
  });

  factory PreTripChapter.fromJson(Map<String, dynamic> json) {
    return PreTripChapter(
      chapterId: json['chapter_id'] as int,
      chapterTitle: TitleBlock.fromJson(json['chapter_title']),
      steps: List<PreTripStep>.from(
        (json['steps'] as List).map((x) => PreTripStep.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'chapter_id': chapterId,
        'chapter_title': chapterTitle.toJson(),
        'steps': steps.map((x) => x.toJson()).toList(),
      };

  @override
  List<Object?> get props => [chapterId, chapterTitle, steps];
}

class TitleBlock extends Equatable {
  final String ru;
  final String en;
  final String uk;
  final String es;
  final String pronunciation;

  const TitleBlock({
    required this.ru,
    required this.en,
    required this.uk,
    required this.es,
    required this.pronunciation,
  });

  factory TitleBlock.fromJson(Map<String, dynamic> json) {
    return TitleBlock(
      ru: json['ru'] ?? '',
      en: json['en'] ?? '',
      uk: json['uk'] ?? '',
      es: json['es'] ?? '',
      pronunciation: json['pronunciation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'ru': ru,
        'en': en,
        'uk': uk,
        'es': es,
        'pronunciation': pronunciation,
      };

  @override
  List<Object?> get props => [ru, en, uk, es, pronunciation];
}

class PreTripStep extends Equatable {
  final String ru;
  final String en;
  final String uk;
  final String es;
  final String pronunciation;

  const PreTripStep({
    required this.ru,
    required this.en,
    required this.uk,
    required this.es,
    required this.pronunciation,
  });

  factory PreTripStep.fromJson(Map<String, dynamic> json) {
    return PreTripStep(
      ru: json['ru'] ?? '',
      en: json['en'] ?? '',
      uk: json['uk'] ?? '',
      es: json['es'] ?? '',
      pronunciation: json['pronunciation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'ru': ru,
        'en': en,
        'uk': uk,
        'es': es,
        'pronunciation': pronunciation,
      };

  @override
  List<Object?> get props => [ru, en, uk, es, pronunciation];
}

