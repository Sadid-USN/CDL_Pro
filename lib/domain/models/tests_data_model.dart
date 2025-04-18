import 'package:equatable/equatable.dart';

class TestsDataModel extends Equatable {
  final Chapters chapters;

  const TestsDataModel({required this.chapters});

  factory TestsDataModel.fromJson(Map<String, dynamic> json) {
    return TestsDataModel(chapters: Chapters.fromJson(json['chapters']));
  }

  Map<String, dynamic> toJson() {
    return {'chapters': chapters.toJson()};
  }

  TestsDataModel copyWith({Chapters? chapters}) {
    return TestsDataModel(chapters: chapters ?? this.chapters);
  }

  @override
  List<Object?> get props => [chapters];
}

class Chapters extends Equatable {
  final GeneralKnowledge generalKnowledge;
  final Combination combination;
  final AirBrakes airBrakes;
  final Tanker tanker;
  final DoubleAndTriple doubleAndTriple;
  final HazMat hazMat;

  const Chapters({
    required this.generalKnowledge,
    required this.combination,
    required this.airBrakes,
    required this.tanker,
    required this.doubleAndTriple,
    required this.hazMat,
  });

  factory Chapters.fromJson(Map<String, dynamic> json) {
    return Chapters(
      generalKnowledge: GeneralKnowledge.fromJson(json['general_knowledge']),
      combination: Combination.fromJson(json['combination']),
      airBrakes: AirBrakes.fromJson(json['airBrakes']),
      tanker: Tanker.fromJson(json['tanker']),
      doubleAndTriple: DoubleAndTriple.fromJson(json['doubleAndTriple']),
      hazMat: HazMat.fromJson(json['hazMat']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'general_knowledge': generalKnowledge.toJson(),
      'combination': combination.toJson(),
      'airBrakes': airBrakes.toJson(),
      'tanker': tanker.toJson(),
      'doubleAndTriple': doubleAndTriple.toJson(),
      'hazMat': hazMat.toJson(),
    };
  }

  Chapters copyWith({
    GeneralKnowledge? generalKnowledge,
    Combination? combination,
    AirBrakes? airBrakes,
    Tanker? tanker,
    DoubleAndTriple? doubleAndTriple,
    HazMat? hazMat,
  }) {
    return Chapters(
      generalKnowledge: generalKnowledge ?? this.generalKnowledge,
      combination: combination ?? this.combination,
      airBrakes: airBrakes ?? this.airBrakes,
      tanker: tanker ?? this.tanker,
      doubleAndTriple: doubleAndTriple ?? this.doubleAndTriple,
      hazMat: hazMat ?? this.hazMat,
    );
  }

  @override
  List<Object?> get props => [
    generalKnowledge,
    combination,
    airBrakes,
    tanker,
    doubleAndTriple,
    hazMat,
  ];
}

class GeneralKnowledge extends Equatable {
  final int freeLimit;
  final int total;
  final Map<String, Question> questions;

  const GeneralKnowledge({
    required this.freeLimit,
    required this.total,
    required this.questions,
  });

  factory GeneralKnowledge.fromJson(Map<String, dynamic> json) {
    return GeneralKnowledge(
      freeLimit: json['free_limit'] as int,
      total: json['total'] as int,
      questions: (json['questions'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, Question.fromJson(value['en'])),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'free_limit': freeLimit,
      'total': total,
      'questions': questions.map(
        (key, value) => MapEntry(key, {'en': value.toJson()}),
      ),
    };
  }

  GeneralKnowledge copyWith({
    int? freeLimit,
    int? total,
    Map<String, Question>? questions,
  }) {
    return GeneralKnowledge(
      freeLimit: freeLimit ?? this.freeLimit,
      total: total ?? this.total,
      questions: questions ?? this.questions,
    );
  }

  @override
  List<Object?> get props => [freeLimit, total, questions];
}

// Аналогичные классы для Combination, AirBrakes, Tanker, DoubleAndTriple, HazMat
// Они имеют одинаковую структуру с GeneralKnowledge

class Combination extends Equatable {
  final int freeLimit;
  final int total;
  final Map<String, Question> questions;

  const Combination({
    required this.freeLimit,
    required this.total,
    required this.questions,
  });

  factory Combination.fromJson(Map<String, dynamic> json) {
    return Combination(
      freeLimit: json['free_limit'] as int,
      total: json['total'] as int,
      questions: (json['questions'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, Question.fromJson(value['en'])),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'free_limit': freeLimit,
      'total': total,
      'questions': questions.map(
        (key, value) => MapEntry(key, {'en': value.toJson()}),
      ),
    };
  }

  Combination copyWith({
    int? freeLimit,
    int? total,
    Map<String, Question>? questions,
  }) {
    return Combination(
      freeLimit: freeLimit ?? this.freeLimit,
      total: total ?? this.total,
      questions: questions ?? this.questions,
    );
  }

  @override
  List<Object?> get props => [freeLimit, total, questions];
}

class AirBrakes extends Equatable {
  final int freeLimit;
  final int total;
  final Map<String, Question> questions;

  const AirBrakes({
    required this.freeLimit,
    required this.total,
    required this.questions,
  });

  factory AirBrakes.fromJson(Map<String, dynamic> json) {
    return AirBrakes(
      freeLimit: json['free_limit'] as int,
      total: json['total'] as int,
      questions: (json['questions'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, Question.fromJson(value['en'])),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'free_limit': freeLimit,
      'total': total,
      'questions': questions.map(
        (key, value) => MapEntry(key, {'en': value.toJson()}),
      ),
    };
  }

  AirBrakes copyWith({
    int? freeLimit,
    int? total,
    Map<String, Question>? questions,
  }) {
    return AirBrakes(
      freeLimit: freeLimit ?? this.freeLimit,
      total: total ?? this.total,
      questions: questions ?? this.questions,
    );
  }

  @override
  List<Object?> get props => [freeLimit, total, questions];
}

class Tanker extends Equatable {
  final int freeLimit;
  final int total;
  final Map<String, Question> questions;

  const Tanker({
    required this.freeLimit,
    required this.total,
    required this.questions,
  });

  factory Tanker.fromJson(Map<String, dynamic> json) {
    return Tanker(
      freeLimit: json['free_limit'] as int,
      total: json['total'] as int,
      questions: (json['questions'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, Question.fromJson(value['en'])),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'free_limit': freeLimit,
      'total': total,
      'questions': questions.map(
        (key, value) => MapEntry(key, {'en': value.toJson()}),
      ),
    };
  }

  Tanker copyWith({
    int? freeLimit,
    int? total,
    Map<String, Question>? questions,
  }) {
    return Tanker(
      freeLimit: freeLimit ?? this.freeLimit,
      total: total ?? this.total,
      questions: questions ?? this.questions,
    );
  }

  @override
  List<Object?> get props => [freeLimit, total, questions];
}

class DoubleAndTriple extends Equatable {
  final int freeLimit;
  final int total;
  final Map<String, Question> questions;

  const DoubleAndTriple({
    required this.freeLimit,
    required this.total,
    required this.questions,
  });

  factory DoubleAndTriple.fromJson(Map<String, dynamic> json) {
    return DoubleAndTriple(
      freeLimit: json['free_limit'] as int,
      total: json['total'] as int,
      questions: (json['questions'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, Question.fromJson(value['en'])),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'free_limit': freeLimit,
      'total': total,
      'questions': questions.map(
        (key, value) => MapEntry(key, {'en': value.toJson()}),
      ),
    };
  }

  DoubleAndTriple copyWith({
    int? freeLimit,
    int? total,
    Map<String, Question>? questions,
  }) {
    return DoubleAndTriple(
      freeLimit: freeLimit ?? this.freeLimit,
      total: total ?? this.total,
      questions: questions ?? this.questions,
    );
  }

  @override
  List<Object?> get props => [freeLimit, total, questions];
}

class HazMat extends Equatable {
  final int freeLimit;
  final int total;
  final Map<String, Question> questions;

  const HazMat({
    required this.freeLimit,
    required this.total,
    required this.questions,
  });

  factory HazMat.fromJson(Map<String, dynamic> json) {
    return HazMat(
      freeLimit: json['free_limit'] as int,
      total: json['total'] as int,
      questions: (json['questions'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, Question.fromJson(value['en'])),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'free_limit': freeLimit,
      'total': total,
      'questions': questions.map(
        (key, value) => MapEntry(key, {'en': value.toJson()}),
      ),
    };
  }

  HazMat copyWith({
    int? freeLimit,
    int? total,
    Map<String, Question>? questions,
  }) {
    return HazMat(
      freeLimit: freeLimit ?? this.freeLimit,
      total: total ?? this.total,
      questions: questions ?? this.questions,
    );
  }

  @override
  List<Object?> get props => [freeLimit, total, questions];
}

class Question extends Equatable {
  final String question;
  final Map<String, String> options;
  final String correctOption;
  final String description;

  const Question({
    required this.question,
    required this.options,
    required this.correctOption,
    required this.description,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] as String,
      options: (json['options'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, value as String),
      ),
      correctOption: json['correct_option'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correct_option': correctOption,
      'description': description,
    };
  }

  Question copyWith({
    String? question,
    Map<String, String>? options,
    String? correctOption,
    String? description,
  }) {
    return Question(
      question: question ?? this.question,
      options: options ?? this.options,
      correctOption: correctOption ?? this.correctOption,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [question, options, correctOption, description];
}
