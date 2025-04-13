import 'package:equatable/equatable.dart';

class RoadSignModel extends Equatable {
  final String enTitle;
  final String ruTitle;
  final String imageUrl;

  const RoadSignModel({
    required this.enTitle,
    required this.ruTitle,
    required this.imageUrl,
  });

  // Для десериализации JSON в объект
  factory RoadSignModel.fromJson(Map<String, dynamic> json) {
    return RoadSignModel(
      enTitle: json['enTitle'] ?? '',
      ruTitle: json['ruTitle'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  // Для сериализации объекта в JSON
  Map<String, dynamic> toJson() {
    return {'enTitle': enTitle, 'ruTitle': ruTitle, 'imageUrl': imageUrl};
  }

  // Метод copyWith для обновления модели
  RoadSignModel copyWith({String? enTitle, String? ruTitle, String? imageUrl}) {
    return RoadSignModel(
      enTitle: enTitle ?? this.enTitle,
      ruTitle: ruTitle ?? this.ruTitle,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [enTitle, ruTitle, imageUrl];
}

class RoadSignListModel {
  final List<RoadSignModel> signs;

  const RoadSignListModel({required this.signs});

  factory RoadSignListModel.fromJson(Map<String, dynamic> json) {
    final signsList =
        (json['signs'] as List)
            .map((item) => RoadSignModel.fromJson(item))
            .toList();
    return RoadSignListModel(signs: signsList);
  }

  Map<String, dynamic> toJson() {
    return {'signs': signs.map((sign) => sign.toJson()).toList()};
  }
}
