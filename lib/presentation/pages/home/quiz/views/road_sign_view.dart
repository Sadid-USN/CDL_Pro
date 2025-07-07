import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/presentation/pages/home/quiz/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:local_hero_transform/local_hero_transform.dart';

class RoadSignView extends StatefulWidget {
  final List<QueryDocumentSnapshot> docs;

  const RoadSignView({super.key, required this.docs});

  @override
  State<RoadSignView> createState() => _RoadSignViewState();
}

class _RoadSignViewState extends State<RoadSignView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this,   initialIndex: 1,);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signs = _processDocs(widget.docs);

    return Column(
      children: [
        const ZoomImageButton(),
        _buildViewToggleButtons(),
        Expanded(
          child: LocalHeroViews(
            tabController: _tabController,
            textDirection: TextDirection.ltr,
            itemCount: signs.length,
            itemsModel:
                (index) => ItemsModel(
                  name: Text(signs[index].enTitle),
                  title: Text(
                    signs[index].ruTitle,
                    style: AppTextStyles.merriweatherBold12.copyWith(
                      color: AppColors.darkBackground,
                    ),
                  ),
                  subTitle: const SizedBox(),
                  favoriteIconButton: SizedBox.shrink(),
                  image: DecorationImage(
                    image: NetworkImage(signs[index].imageUrl),
                    fit: BoxFit.contain,
                  ),
                ),
            onPressedCard: (int index) {
              final isGridView = _tabController.index == 0;
              _tabController.animateTo(isGridView ? 0 : 1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildViewToggleButtons() {
   // final isGridView = _tabController.index == 0;

    return AnimatedBuilder(
      animation: _tabController.animation!,
      builder: (context, _) {
        final isGrid = _tabController.index == 0;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
           
              IconButton(
                icon: Icon(
                  Icons.grid_view,
                  color: isGrid ? AppColors.lightPrimary : Colors.grey,
                ),
                onPressed: () {
                  _tabController.animateTo(0);
                },
                tooltip: 'Grid view',
              ),
                 IconButton(
                icon: Icon(
                  Icons.list,
                  color: isGrid ? Colors.grey : AppColors.lightPrimary,
                ),
                onPressed: () {
                  _tabController.animateTo(1);
                },
                tooltip: 'List view',
              ),
            ],
          ),
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
}
