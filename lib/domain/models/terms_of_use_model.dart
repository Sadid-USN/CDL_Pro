import 'package:equatable/equatable.dart';

class TermsOfUseModel extends Equatable {
  final Map<String, LocalizedTerms> terms;

  const TermsOfUseModel({required this.terms});

  factory TermsOfUseModel.fromJson(Map<String, dynamic> json) {
    final termsMap = <String, LocalizedTerms>{};
    final data = json['terms_of_use'] as Map<String, dynamic>;
    data.forEach((lang, content) {
      termsMap[lang] = LocalizedTerms.fromJson(content);
    });
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
  final TermsSections sections;

  const LocalizedTerms({
    required this.title,
    required this.effectiveDate,
    required this.sections,
  });

  factory LocalizedTerms.fromJson(Map<String, dynamic> json) {
    return LocalizedTerms(
      title: json['title'],
      effectiveDate: json['effective_date'],
      sections: TermsSections.fromJson(json['sections']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'effective_date': effectiveDate,
      'sections': sections.toJson(),
    };
  }

  LocalizedTerms copyWith({
    String? title,
    String? effectiveDate,
    TermsSections? sections,
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

class TermsSections extends Equatable {
  final String general;
  final String payments;
  final String content;
  final String disclaimer;
  final String privacy;
  final String modifications;
  final String contact;

  const TermsSections({
    required this.general,
    required this.payments,
    required this.content,
    required this.disclaimer,
    required this.privacy,
    required this.modifications,
    required this.contact,
  });

  factory TermsSections.fromJson(Map<String, dynamic> json) {
    return TermsSections(
      general: json['general'],
      payments: json['payments'],
      content: json['content'],
      disclaimer: json['disclaimer'],
      privacy: json['privacy'],
      modifications: json['modifications'],
      contact: json['contact'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'general': general,
      'payments': payments,
      'content': content,
      'disclaimer': disclaimer,
      'privacy': privacy,
      'modifications': modifications,
      'contact': contact,
    };
  }

  TermsSections copyWith({
    String? general,
    String? payments,
    String? content,
    String? disclaimer,
    String? privacy,
    String? modifications,
    String? contact,
  }) {
    return TermsSections(
      general: general ?? this.general,
      payments: payments ?? this.payments,
      content: content ?? this.content,
      disclaimer: disclaimer ?? this.disclaimer,
      privacy: privacy ?? this.privacy,
      modifications: modifications ?? this.modifications,
      contact: contact ?? this.contact,
    );
  }

  @override
  List<Object?> get props => [
        general,
        payments,
        content,
        disclaimer,
        privacy,
        modifications,
        contact,
      ];
}
