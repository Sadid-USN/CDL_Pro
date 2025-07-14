import 'package:equatable/equatable.dart';

class TestsDataModel extends Equatable {
  final Chapters chapters;

  // Кэш для распарсенных вопросов
  final Map<String, List<Question>> _questionsCache = {};

  TestsDataModel({required this.chapters});

  factory TestsDataModel.fromJson(Map<String, dynamic> json) {
    return TestsDataModel(chapters: Chapters.fromJson(json['chapters']));
  }

  Map<String, dynamic> toJson() {
    return {'chapters': chapters.toJson()};
  }

  TestsDataModel copyWith({Chapters? chapters}) {
    return TestsDataModel(chapters: chapters ?? this.chapters);
  }

  /// Получает все вопросы по ключу категории с кэшированием
  List<Question> getQuestionsForCategory(String categoryKey) {
    // Если вопросы уже есть в кэше — сразу возвращаем
    if (_questionsCache.containsKey(categoryKey)) {
      return _questionsCache[categoryKey]!;
    }

    // Получаем нужную категорию
    final category = _getCategoryByKey(categoryKey);
    if (category == null) return [];

    // Кэшируем список вопросов из категории
    _questionsCache[categoryKey] = category.parsedQuestions;

    return category.parsedQuestions;
  }

  /// Получает TestChapter по ключу
  TestChapter? _getCategoryByKey(String key) {
    switch (key) {
      case 'general_knowledge':
        return chapters.generalKnowledge;
      case 'combination':
        return chapters.combination;
      case 'airBrakes':
        return chapters.airBrakes;
      case 'tanker':
        return chapters.tanker;
      case 'doubleAndTriple':
        return chapters.doubleAndTriple;
      case 'hazMat':
        return chapters.hazMat;
      default:
        return null;
    }
  }

  /// Очищает кэш вопросов
  void clearQuestionsCache() {
    _questionsCache.clear();
  }

  @override
  List<Object?> get props => [chapters];
}

class TestChapter extends Equatable {
  final int freeLimit;
  final int total;
  final Map<String, Question> questions;
  final List<Question> parsedQuestions;

  const TestChapter({
    required this.freeLimit,
    required this.total,
    required this.questions,
    required this.parsedQuestions,
  });

  factory TestChapter.fromJson(Map<String, dynamic> json) {
    final questions = <String, Question>{};
    final questionsJson = json['questions'] as Map<String, dynamic>? ?? {};

    questionsJson.forEach((key, questionData) {
      if (questionData is Map<String, dynamic>) {
        // Handle both localized and non-localized questions
        if (questionData.containsKey('en')) {
          questions[key] = Question.fromJson(questionData['en'], key: key);
        } else {
          questions[key] = Question.fromJson(questionData, key: key);
        }
      }
    });

    /// ✅ Собираем список вопросов для быстрого доступа
    final parsedQuestions = questions.values.toList();

    return TestChapter(
      freeLimit: json['free_limit'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
      questions: questions,
      parsedQuestions: parsedQuestions,
    );
  }

  Map<String, dynamic> toJson() {
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
    List<Question>? parsedQuestions,
  }) {
    return TestChapter(
      freeLimit: freeLimit ?? this.freeLimit,
      total: total ?? this.total,
      questions: questions ?? this.questions,
      parsedQuestions: parsedQuestions ?? this.parsedQuestions,
    );
  }

  @override
  List<Object?> get props => [freeLimit, total, questions, parsedQuestions];
}

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

class Question extends Equatable {
  final String question;
  final Map<String, String> options;
  final String correctOption;
  final String description;
  final List<String>? images;
  final String? customId;
  final String id; // Now we'll always have an ID

  const Question({
    required this.question,
    required this.options,
    required this.correctOption,
    required this.description,
    this.images,
    this.customId,
    required this.id, // Made required as it's now explicitly set
  });

 factory Question.fromJson(Map<String, dynamic> json, {required String key}) {
  // Если вопрос локализован (содержит 'en', 'ru', 'uk', 'es' и т.д.)
  final supportedLocales = ['en', 'ru', 'uk', 'es'];
  final localeKey = json.keys.firstWhere(
    (k) => supportedLocales.contains(k),
    orElse: () => 'en', // fallback на английский, если нет локали
  );

  // Если нашли локализацию — парсим её, иначе считаем, что вопрос нелокализован
  final questionData = (localeKey != 'en') ? json[localeKey] : json;

  // Получаем ID (если есть в данных, иначе используем ключ)
  final id = questionData['id']?.toString() ?? key;

  return Question(
    id: id,
    customId: id,
    question: questionData['question'] as String? ?? '',
    options: Map<String, String>.from(questionData['options'] as Map? ?? {}),
    correctOption: questionData['correct_option'] as String? ?? '',
    description: questionData['description'] as String? ?? '',
    images: (questionData['images'] as List?)?.cast<String>(),
  );
}
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correct_option': correctOption,
      'description': description,
      if (images != null) 'images': images,
    };
  }

  @override
  List<Object?> get props => [
    id, // Now id is part of equality check
    question,
    options,
    correctOption,
    description,
    images,
  ];
}
