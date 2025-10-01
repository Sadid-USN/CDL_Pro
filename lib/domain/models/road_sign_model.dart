import 'package:equatable/equatable.dart';


// Модель для ответа с дорожными знаками
class RoadSignResponse extends Equatable {
  final int total;
  final Map<String, RoadSignModel> signs;

  const RoadSignResponse({
    required this.total,
    required this.signs,
  });

  factory RoadSignResponse.fromJson(Map<String, dynamic> json) {
    return RoadSignResponse(
      total: json['total'] ?? 0,
      signs: (json['signs'] as Map<String, dynamic>?)?.map((key, value) =>
          MapEntry(key, RoadSignModel.fromJson(key, value))) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'signs': signs.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  @override
  List<Object?> get props => [total, signs];

  RoadSignResponse copyWith({
    int? total,
    Map<String, RoadSignModel>? signs,
  }) {
    return RoadSignResponse(
      total: total ?? this.total,
      signs: signs ?? this.signs,
    );
  }
}

class RoadSignModel extends Equatable {
  final String id;
  final String imageUrl;
  final Map<String, QuizModel> quiz; // 'en', 'ru', 'uk', 'es'

  const RoadSignModel({
    required this.id,
    required this.imageUrl,
    required this.quiz,
  });

factory RoadSignModel.fromJson(String id, Map<String, dynamic> json) {
  final quiz = <String, QuizModel>{};
  
  // Проверяем все возможные языки
  for (final lang in ['en', 'ru', 'uk', 'es']) {
    if (json[lang] != null && json[lang] is Map<String, dynamic>) {
      quiz[lang] = QuizModel.fromJson(Map<String, dynamic>.from(json[lang]));
    }
  }

  return RoadSignModel(
    id: id,
    imageUrl: json['imageUrl'] ?? '',
    quiz: quiz,
  );
}

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      ...quiz.map((lang, quizData) => MapEntry(lang, quizData.toJson())),
    };
  }

  @override
  List<Object?> get props => [id, imageUrl, quiz];
}


class QuizModel extends Equatable {
  final String question;
  final Map<String, String> options; // ключи: 'A', 'B', 'C'
  final String correctAnswer;
  final String explanation;
  final String signName; // ← ДОБАВЛЕНО ПОЛЕ

  const QuizModel({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.signName, // ← ДОБАВЛЕНО В КОНСТРУКТОР
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      question: json['question'] ?? '',
      options: Map<String, String>.from(json['options'] ?? {}),
      correctAnswer: json['correctAnswer'] ?? '',
      explanation: json['explanation'] ?? '',
      signName: json['signName'] ?? '', // ← ДОБАВЛЕНО ПАРСИНГ
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'signName': signName, // ← ДОБАВЛЕНО В СЕРИАЛИЗАЦИЮ
    };
  }

  @override
  List<Object?> get props => [
    question, 
    options, 
    correctAnswer, 
    explanation, 
    signName // ← ДОБАВЛЕНО В EQUATABLE
  ];

  QuizModel copyWith({
    String? question,
    Map<String, String>? options,
    String? correctAnswer,
    String? explanation,
    String? signName, // ← ДОБАВЛЕНО В COPYWITH
  }) {
    return QuizModel(
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanation: explanation ?? this.explanation,
      signName: signName ?? this.signName, // ← ДОБАВЛЕНО
    );
  }
}


