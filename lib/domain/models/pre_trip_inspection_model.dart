import 'package:equatable/equatable.dart';



class PreTripInspectionListModel extends Equatable {
  final List<PreTripSection> preTripInspection;

  const PreTripInspectionListModel({required this.preTripInspection});

  factory PreTripInspectionListModel.fromJson(Map<String, dynamic> json) {
    return PreTripInspectionListModel(
      preTripInspection: List<PreTripSection>.from(
        json['pre_trip_inspection'].map((x) => PreTripSection.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'pre_trip_inspection': preTripInspection.map((x) => x.toJson()).toList(),
      };

  PreTripInspectionListModel copyWith({
    List<PreTripSection>? preTripInspection,
  }) {
    return PreTripInspectionListModel(
      preTripInspection: preTripInspection ?? this.preTripInspection,
    );
  }

  @override
  List<Object?> get props => [preTripInspection];
}

class PreTripSection extends Equatable {
  final int id;
  final String ruTitle;
  final String enTitle;
  final List<PreTripItem> content;

  const PreTripSection({
    required this.id,
    required this.ruTitle,
    required this.enTitle,
    required this.content,
  });

  factory PreTripSection.fromJson(Map<String, dynamic> json) {
    return PreTripSection(
      id: json['id'],
      ruTitle: json['ruTitle'],
      enTitle: json['enTitle'],
      content: List<PreTripItem>.from(
        json['content'].map((x) => PreTripItem.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'ruTitle': ruTitle,
        'enTitle': enTitle,
        'content': content.map((x) => x.toJson()).toList(),
      };

  PreTripSection copyWith({
    int? id,
    String? ruTitle,
    String? enTitle,
    List<PreTripItem>? content,
  }) {
    return PreTripSection(
      id: id ?? this.id,
      ruTitle: ruTitle ?? this.ruTitle,
      enTitle: enTitle ?? this.enTitle,
      content: content ?? this.content,
    );
  }

  @override
  List<Object?> get props => [id, ruTitle, enTitle, content];
}

class PreTripItem extends Equatable {
  final String ruText;
  final String enText;
  final String pronunciation;

  const PreTripItem({
    required this.ruText,
    required this.enText,
    required this.pronunciation,
  });

  factory PreTripItem.fromJson(Map<String, dynamic> json) {
    return PreTripItem(
      ruText: json['ruText'],
      enText: json['enText'],
      pronunciation: json['pronunciation'],
    );
  }

  Map<String, dynamic> toJson() => {
        'ruText': ruText,
        'enText': enText,
        'pronunciation': pronunciation,
      };

  PreTripItem copyWith({
    String? ruText,
    String? enText,
    String? pronunciation,
  }) {
    return PreTripItem(
      ruText: ruText ?? this.ruText,
      enText: enText ?? this.enText,
      pronunciation: pronunciation ?? this.pronunciation,
    );
  }

  @override
  List<Object?> get props => [ruText, enText, pronunciation];
}
