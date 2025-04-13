import 'package:equatable/equatable.dart';

class TestsDataModel extends Equatable {
  final Map<String, ChapterModel>? chapters;

  const TestsDataModel({this.chapters});

  TestsDataModel copyWith({
    bool? isPremium,
    Map<String, ChapterModel>? chapters,
  }) {
    return TestsDataModel(chapters: chapters ?? this.chapters);
  }

  @override
  List<Object?> get props => [chapters];

  factory TestsDataModel.fromJson(Map<String, dynamic> json) {
    final chaptersJson = json['chapters'] as Map<String, dynamic>?;
    return TestsDataModel(
      chapters: chaptersJson?.map(
        (key, value) => MapEntry(key, ChapterModel.fromJson(value)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'chapters': chapters?.map((key, value) => MapEntry(key, value.toJson())),
  };
}

class ChapterModel extends Equatable {
  final int? freeLimit;
  final int? total;
  final Map<String, QuestionLocalizedModel>? questions;

  const ChapterModel({this.freeLimit, this.total, this.questions});

  ChapterModel copyWith({
    int? freeLimit,
    int? total,
    Map<String, QuestionLocalizedModel>? questions,
  }) {
    return ChapterModel(
      freeLimit: freeLimit ?? this.freeLimit,
      total: total ?? this.total,
      questions: questions ?? this.questions,
    );
  }

  @override
  List<Object?> get props => [freeLimit, total, questions];

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    final questionsJson = json['questions'] as Map<String, dynamic>?;
    return ChapterModel(
      freeLimit: json['freeLimit'] as int?,
      total: json['total'] as int?,
      questions: questionsJson?.map(
        (key, value) => MapEntry(key, QuestionLocalizedModel.fromJson(value)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'freeLimit': freeLimit,
    'total': total,
    'questions': questions?.map((key, value) => MapEntry(key, value.toJson())),
  };
}

class QuestionLocalizedModel extends Equatable {
  final Map<String, QuestionModel>? translations;

  const QuestionLocalizedModel({this.translations});

  QuestionLocalizedModel copyWith({Map<String, QuestionModel>? translations}) {
    return QuestionLocalizedModel(
      translations: translations ?? this.translations,
    );
  }

  @override
  List<Object?> get props => [translations];

  factory QuestionLocalizedModel.fromJson(Map<String, dynamic> json) {
    return QuestionLocalizedModel(
      translations: json.map(
        (languageKey, questionData) =>
            MapEntry(languageKey, QuestionModel.fromJson(questionData)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    if (translations != null)
      for (var entry in translations!.entries) entry.key: entry.value.toJson(),
  };

  QuestionModel? getTranslation(String languageCode) {
    return translations?[languageCode];
  }
}

class QuestionModel extends Equatable {
  final String? question;
  final Map<String, String>? options;
  final String? correctOption;
  final String? description;

  const QuestionModel({
    this.question,
    this.options,
    this.correctOption,
    this.description,
  });

  QuestionModel copyWith({
    String? question,
    Map<String, String>? options,
    String? correctOption,
    String? description,
  }) {
    return QuestionModel(
      question: question ?? this.question,
      options: options ?? this.options,
      correctOption: correctOption ?? this.correctOption,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [question, options, correctOption, description];

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final optionsJson = json['options'] as Map<String, dynamic>?;
    return QuestionModel(
      question: json['question'] as String?,
      options: optionsJson?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
      correctOption: json['correct_option'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'question': question,
    'options': options,
    'correct_option': correctOption,
    'description': description,
  };
}
