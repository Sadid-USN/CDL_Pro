import 'package:equatable/equatable.dart';

class TestChapter extends Equatable {
  final int freeLimit;
  final int total;
  final Map<String, Question> questions;

  const TestChapter({
    required this.freeLimit,
    required this.total,
    required this.questions,
  });

  factory TestChapter.fromJson(Map<String, dynamic> json) {
    final questions = <String, Question>{};

    final questionsJson = json['questions'] as Map<String, dynamic>? ?? {};

    questionsJson.forEach((key, questionData) {
      // Поддержка как обычных вопросов, так и локализованных (с ключами 'uk', 'en' и т.д.)
      if (questionData is Map<String, dynamic>) {
        if (questionData.containsKey('uk') ||
            questionData.containsKey('en') ||
            questionData.containsKey('ru') ||
            questionData.containsKey('es')) {
          // Это локализованный вопрос - извлекаем нужную локализацию
          questions[key] = Question.fromJson(questionData);
        } else {
          // Это обычный вопрос
          questions[key] = Question.fromJson(questionData);
        }
      }
    });

    return TestChapter(
      freeLimit: json['free_limit'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
      questions: questions,
    );
  }

  Map<String, dynamic> toJson() {
    // При преобразовании в JSON сохраняем структуру без локализации
    // (если нужно сохранить локализацию, потребуется дополнительная логика)
    return {
      'free_limit': freeLimit,
      'total': total,
      'questions': questions.map(
        (key, question) => MapEntry(key, question.toJson()),
      ),
    };
  }

  TestChapter copyWith({
    int? freeLimit,
    int? total,
    Map<String, Question>? questions,
  }) {
    return TestChapter(
      freeLimit: freeLimit ?? this.freeLimit,
      total: total ?? this.total,
      questions: questions ?? this.questions,
    );
  }

  @override
  List<Object?> get props => [freeLimit, total, questions];
}

// Обновленная модель Chapters с использованием унифицированной TestChapter
class Chapters extends Equatable {
  final TestChapter generalKnowledge;
  final TestChapter combination;
  final TestChapter airBrakes;
  final TestChapter tanker;
  final TestChapter doubleAndTriple;
  final TestChapter hazMat;

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
      generalKnowledge: TestChapter.fromJson(json['general_knowledge']),
      combination: TestChapter.fromJson(json['combination']),
      airBrakes: TestChapter.fromJson(json['airBrakes']),
      tanker: TestChapter.fromJson(json['tanker']),
      doubleAndTriple: TestChapter.fromJson(json['doubleAndTriple']),
      hazMat: TestChapter.fromJson(json['hazMat']),
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
    TestChapter? generalKnowledge,
    TestChapter? combination,
    TestChapter? airBrakes,
    TestChapter? tanker,
    TestChapter? doubleAndTriple,
    TestChapter? hazMat,
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

// Модель вопроса остается без изменений
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
    // Если вопрос локализован (содержит ключ языка)
    if (json.containsKey('uk') ||
        json.containsKey('en') ||
        json.containsKey('ru') ||
        json.containsKey('es')) {
      // Получаем локализованную версию (например, 'uk')
      final localized = json['uk'] ?? json['en'] ?? json['ru'] ?? json['es'];
      return Question(
        question: localized['question'] as String? ?? '',
        options: Map<String, String>.from(localized['options'] as Map? ?? {}),
        correctOption: localized['correct_option'] as String? ?? '',
        description: localized['description'] as String? ?? '',
      );
    }

    // Обычная структура вопроса
    return Question(
      question: json['question'] as String? ?? '',
      options: Map<String, String>.from(json['options'] as Map? ?? {}),
      correctOption: json['correct_option'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  // Остальные методы остаются без изменений
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correct_option': correctOption,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [question, options, correctOption, description];
}

// Основная модель данных тестов
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

class QuestionLocalized extends Equatable {
  final Map<String, Question> translations;

  const QuestionLocalized({required this.translations});

  factory QuestionLocalized.fromJson(Map<String, dynamic> json) {
    return QuestionLocalized(
      translations: (json).map(
        (key, value) => MapEntry(key, Question.fromJson(value)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return translations.map((key, value) => MapEntry(key, value.toJson()));
  }

  QuestionLocalized copyWith({Map<String, Question>? translations}) {
    return QuestionLocalized(translations: translations ?? this.translations);
  }

  @override
  List<Object?> get props => [translations];
}
