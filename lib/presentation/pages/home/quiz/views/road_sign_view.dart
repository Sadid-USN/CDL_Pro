import 'package:cdl_pro/domain/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RoadSignView extends StatelessWidget {
  final List<QueryDocumentSnapshot> docs;

  const RoadSignView({super.key, required this.docs});

  @override
  Widget build(BuildContext context) {
    final data = docs.first.data() as Map<String, dynamic>;
    final Map<String, dynamic> signsMap = data['signs'] ?? {};

    final signs = signsMap.entries.map((entry) {
      final id = entry.key;
      final json = entry.value as Map<String, dynamic>;
      return RoadSignModel.fromJson(id, json);
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: signs.length,
      itemBuilder: (context, index) {
        final model = signs[index];

        return ListTile(
          // leading: Image.network(
          //   model.imageUrl,
          //   width: 40,
          //   height: 40,
          //   fit: BoxFit.cover,
          // ),
          title: Text(model.enTitle),
          subtitle: Text(model.ruTitle),
        );
      },
    );
  }
}
