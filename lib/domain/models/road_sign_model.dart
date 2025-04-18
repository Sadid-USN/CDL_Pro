import 'package:equatable/equatable.dart';


// Модель для всего ответа
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

// Модель для отдельного знака
class RoadSignModel extends Equatable {
  final String id;
  final String enTitle;
  final String ruTitle;
  final String imageUrl;

  const RoadSignModel({
    required this.id,
    required this.enTitle,
    required this.ruTitle,
    required this.imageUrl,
  });

  factory RoadSignModel.fromJson(String id, Map<String, dynamic> json) {
    return RoadSignModel(
      id: id,
      enTitle: json['enTitle'] ?? '',
      ruTitle: json['ruTitle'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enTitle': enTitle,
      'ruTitle': ruTitle,
      'imageUrl': imageUrl,
    };
  }

  @override
  List<Object?> get props => [id, enTitle, ruTitle, imageUrl];

  RoadSignModel copyWith({
    String? id,
    String? enTitle,
    String? ruTitle,
    String? imageUrl,
  }) {
    return RoadSignModel(
      id: id ?? this.id,
      enTitle: enTitle ?? this.enTitle,
      ruTitle: ruTitle ?? this.ruTitle,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
