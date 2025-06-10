import 'package:cdl_pro/domain/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PreTripInspectionView extends StatelessWidget {
  final List<QueryDocumentSnapshot> docs;

  const PreTripInspectionView({super.key, required this.docs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final data = docs[index].data() as Map<String, dynamic>;
        final model = PreTripInspectionListModel.fromJson(data);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              model.preTripInspection.map((section) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.enTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ...section.content.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(item.enText),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        );
      },
    );
  }
}
