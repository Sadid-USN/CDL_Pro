import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/presentation/blocs/road_sign_bloc/road_sign.dart';
import 'package:cdl_pro/presentation/pages/home/quiz/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoadSignView extends StatelessWidget {
  final List<QueryDocumentSnapshot> docs;

  const RoadSignView({super.key, required this.docs});

  @override
  Widget build(BuildContext context) {
    final signs = _processDocs(docs);

    return BlocBuilder<RoadSignBloc, AbstractRoadSignState>(
      builder: (context, state) {
        return Column(
          children: [
            const ZoomImageButton(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: signs.length,
                itemBuilder: (context, index) {
                  state as RoadSignState;
                  final model = signs[index];
                  return _buildSignItem(
                    context,
                    model,
                    state.imageHeightFactor,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  List<RoadSignModel> _processDocs(List<QueryDocumentSnapshot> docs) {
    final data = docs.first.data() as Map<String, dynamic>;
    final signsMap = data['signs'] as Map<String, dynamic>? ?? {};

    return signsMap.entries.map((entry) {
        final value = entry.value as Map<String, dynamic>;
        return RoadSignModel.fromJson(entry.key, value);
      }).toList()
      ..sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
  }

  Widget _buildSignItem(
    BuildContext context,
    RoadSignModel model,
    double heightFactor,
  ) {
    return Column(
      children: [
        ListTile(title: Text(model.enTitle), subtitle: Text(model.ruTitle)),
        Card(
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.of(context).size.height * 0.4 * heightFactor,
            ),
            child: Image.network(
              model.imageUrl,
              fit: BoxFit.contain,
              width: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value:
                        loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 48);
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
