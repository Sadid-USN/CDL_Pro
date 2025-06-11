import 'package:equatable/equatable.dart';


class PreTripInspectionListModel extends Equatable {
  final List<PreTripSection> preTripInspection;

  const PreTripInspectionListModel({required this.preTripInspection});

  factory PreTripInspectionListModel.fromJson(Map<String, dynamic> json) {
    final list = json['pre_trip_inspection'] as List<dynamic>?;
    return PreTripInspectionListModel(
      preTripInspection: list != null
          ? list.map((x) => PreTripSection.fromJson(x)).toList()
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

class PreTripSection extends Equatable {
  final int id;
  final List<PreTripContent> content;

  const PreTripSection({required this.id, required this.content});

  factory PreTripSection.fromJson(Map<String, dynamic> json) {
    return PreTripSection(
      id: json['id'],
      content: List<PreTripContent>.from(
        json['content'].map((x) => PreTripContent.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content.map((x) => x.toJson()).toList(),
      };

  @override
  List<Object?> get props => [id, content];
}


class PreTripContent extends Equatable {
  // заголовки (присутствуют только в первом элементе content)
  final String? ruTitle;
  final String? enTitle;
  final String? ukTitle;
  final String? esTitle;

  // текстовые пункты
  final String? ruText;
  final String? enText;
  final String? ukText;
  final String? esText;
  final String? pronunciation;

  const PreTripContent({
    this.ruTitle,
    this.enTitle,
    this.ukTitle,
    this.esTitle,
    this.ruText,
    this.enText,
    this.ukText,
    this.esText,
    this.pronunciation,
  });

  factory PreTripContent.fromJson(Map<String, dynamic> json) {
    return PreTripContent(
      ruTitle: json['ruTitle'],
      enTitle: json['enTitle'],
      ukTitle: json['ukTitle'],
      esTitle: json['esTitle'],
      ruText: json['ruText'],
      enText: json['enText'],
      ukText: json['ukText'],
      esText: json['esText'],
      pronunciation: json['pronunciation'],
    );
  }

  Map<String, dynamic> toJson() => {
        if (ruTitle != null) 'ruTitle': ruTitle,
        if (enTitle != null) 'enTitle': enTitle,
        if (ukTitle != null) 'ukTitle': ukTitle,
        if (esTitle != null) 'esTitle': esTitle,
        if (ruText != null) 'ruText': ruText,
        if (enText != null) 'enText': enText,
        if (ukText != null) 'ukText': ukText,
        if (esText != null) 'esText': esText,
        if (pronunciation != null) 'pronunciation': pronunciation,
      };

  @override
  List<Object?> get props => [
        ruTitle,
        enTitle,
        ukTitle,
        esTitle,
        ruText,
        enText,
        ukText,
        esText,
        pronunciation,
      ];
}
