import 'package:equatable/equatable.dart';


class TermsOfUseModel extends Equatable {
  final Map<String, LocalizedTerms> terms;

  const TermsOfUseModel({required this.terms});

  factory TermsOfUseModel.fromJson(Map<String, dynamic> json) {
    final data = json['terms_of_use'] as Map<String, dynamic>;
    final termsMap = data.map((lang, content) => MapEntry(
          lang,
          LocalizedTerms.fromJson(content as Map<String, dynamic>),
        ));
    return TermsOfUseModel(terms: termsMap);
  }

  Map<String, dynamic> toJson() {
    return {
      'terms_of_use': terms.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  TermsOfUseModel copyWith({
    Map<String, LocalizedTerms>? terms,
  }) {
    return TermsOfUseModel(
      terms: terms ?? this.terms,
    );
  }

  @override
  List<Object?> get props => [terms];
}

class LocalizedTerms extends Equatable {
  final String title;
  final String effectiveDate;
  final List<TermsSection> sections;

  const LocalizedTerms({
    required this.title,
    required this.effectiveDate,
    required this.sections,
  });

  factory LocalizedTerms.fromJson(Map<String, dynamic> json) {
    final sectionsJson = json['sections'] as List<dynamic>;
    final sectionsList = sectionsJson
        .map((section) => TermsSection.fromJson(section as Map<String, dynamic>))
        .toList();

    return LocalizedTerms(
      title: json['title'] as String,
      effectiveDate: json['effective_date'] as String,
      sections: sectionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'effective_date': effectiveDate,
      'sections': sections.map((s) => s.toJson()).toList(),
    };
  }

  LocalizedTerms copyWith({
    String? title,
    String? effectiveDate,
    List<TermsSection>? sections,
  }) {
    return LocalizedTerms(
      title: title ?? this.title,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      sections: sections ?? this.sections,
    );
  }

  @override
  List<Object?> get props => [title, effectiveDate, sections];
}

class TermsSection extends Equatable {
  final String title;
  final String content;

  const TermsSection({
    required this.title,
    required this.content,
  });

  factory TermsSection.fromJson(Map<String, dynamic> json) {
    return TermsSection(
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }

  TermsSection copyWith({
    String? title,
    String? content,
  }) {
    return TermsSection(
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  @override
  List<Object?> get props => [title, content];
}
