import 'package:cdl_pro/domain/models/models.dart';

extension ChaptersExtension on Chapters {
  Map<String, TestChapter> toMap() {
    return {
      'general_knowledge': generalKnowledge,
      'combination': combination,
      'airBrakes': airBrakes,
      'tanker': tanker,
      'doubleAndTriple': doubleAndTriple,
      'hazMat': hazMat,
    };
  }
}