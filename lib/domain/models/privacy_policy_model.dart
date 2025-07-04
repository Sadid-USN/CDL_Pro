import 'package:equatable/equatable.dart';

class PrivacyPolicyModel extends Equatable {
  final Map<String, LocalizedPrivacyPolicy> localized;

  const PrivacyPolicyModel({required this.localized});

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyModel(
      localized: json.map(
        (key, value) => MapEntry(
          key,
          LocalizedPrivacyPolicy.fromJson(value),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return localized.map((key, value) => MapEntry(key, value.toJson()));
  }

  PrivacyPolicyModel copyWith({
    Map<String, LocalizedPrivacyPolicy>? localized,
  }) {
    return PrivacyPolicyModel(
      localized: localized ?? this.localized,
    );
  }

  @override
  List<Object?> get props => [localized];
}

class LocalizedPrivacyPolicy extends Equatable {
  final String effectiveDate;
  final String title;
  final List<PrivacySection> sections;

  const LocalizedPrivacyPolicy({
    required this.effectiveDate,
    required this.title,
    required this.sections,
  });

  factory LocalizedPrivacyPolicy.fromJson(Map<String, dynamic> json) {
    return LocalizedPrivacyPolicy(
      effectiveDate: json['effective_date'] as String,
      title: json['title'] as String,
      sections: (json['sections'] as List)
          .map((e) => PrivacySection.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'effective_date': effectiveDate,
      'title': title,
      'sections': sections.map((e) => e.toJson()).toList(),
    };
  }

  LocalizedPrivacyPolicy copyWith({
    String? effectiveDate,
    String? title,
    List<PrivacySection>? sections,
  }) {
    return LocalizedPrivacyPolicy(
      effectiveDate: effectiveDate ?? this.effectiveDate,
      title: title ?? this.title,
      sections: sections ?? this.sections,
    );
  }

  @override
  List<Object?> get props => [effectiveDate, title, sections];
}

class PrivacySection extends Equatable {
  final String title;
  final String content;

  const PrivacySection({
    required this.title,
    required this.content,
  });

  factory PrivacySection.fromJson(Map<String, dynamic> json) {
    return PrivacySection(
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
      };

  PrivacySection copyWith({
    String? title,
    String? content,
  }) {
    return PrivacySection(
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  @override
  List<Object?> get props => [title, content];
}
