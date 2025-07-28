import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/presentation/blocs/road_sign_bloc/road_sign.dart';
import 'package:cdl_pro/presentation/pages/home/quiz/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class RoadSignView extends StatelessWidget {
  final List<QueryDocumentSnapshot> docs;

  const RoadSignView({super.key, required this.docs});

  List<RoadSignModel> _processDocs(List<QueryDocumentSnapshot> docs) {
    final data = docs.first.data() as Map<String, dynamic>;
    final signsMap = data['signs'] as Map<String, dynamic>? ?? {};

    return signsMap.entries.map((entry) {
        final value = entry.value as Map<String, dynamic>;
        return RoadSignModel.fromJson(entry.key, value);
      }).toList()
      ..sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
  }

  @override
  Widget build(BuildContext context) {
    final heightFactor = MediaQuery.of(context).size.height;
    final signs = _processDocs(docs);

    return BlocBuilder<RoadSignBloc, RoadSignState>(
      builder: (context, state) {
        return Column(
          children: [
            ZoomImageButton(),
            _buildViewToggleButtons(context),

            Expanded(
              child:
                  state.isGridView
                      ? _buildGridView(context, signs, heightFactor)
                      : _buildListView(context, signs, heightFactor),
            ),
          ],
        );
      },
    );
  }

  Widget _buildViewToggleButtons(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.list, color:  AppColors.softBlack,),
            onPressed: () {
              context.read<RoadSignBloc>().add(
                ToggleViewModeEvent(isGridView: false),
              );
            },
            tooltip: 'List view',
          ),
          IconButton(
            icon: const Icon(Icons.grid_view,  color: AppColors.softBlack,),
            onPressed: () {
              context.read<RoadSignBloc>().add(
                ToggleViewModeEvent(isGridView: true),
              );
            },
            tooltip: 'Grid view',
          ),
        ],
      ),
    );
  }

  Widget _buildListView(
    BuildContext context,
    List<RoadSignModel> signs,
    double heightFactor,
  ) {
    return ListView.builder(
      padding:  EdgeInsets.all(12.0),
      itemCount: signs.length,
      itemBuilder: (context, index) {
        final model = signs[index];
        return _buildSignItem(context, model, heightFactor);
      },
    );
  }

  Widget _buildGridView(
    BuildContext context,
    List<RoadSignModel> signs,
    double heightFactor,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 0.8,
      ),
      itemCount: signs.length,
      itemBuilder: (context, index) {
        final model = signs[index];
        return _buildGridItem(context, model, heightFactor);
      },
    );
  }

  Widget _buildGridItem(
    BuildContext context,
    RoadSignModel model,
    double heightFactor,
  ) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                model.imageUrl,
                fit: BoxFit.contain,
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
                  return const Icon(Icons.broken_image, size: 40);
                },
              ),
            ),
          ),
          ListTile(
            title: Text(
              model.enTitle,
              style: AppTextStyles.merriweather10.copyWith(
                color: AppColors.darkBackground,
              ),
            ),
            subtitle: Text(
              model.ruTitle,
              style: AppTextStyles.merriweather10.copyWith(
                color: AppColors.darkBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignItem(
    BuildContext context,
    RoadSignModel model,
    double heightFactor,
  ) {
    return Column(
      children: [
        ListTile(
          title: Text(model.enTitle),
          subtitle: Text(
            model.ruTitle,
            style: AppTextStyles.merriweatherBold12.copyWith(
              color: AppColors.darkBackground,
            ),
          ),
        ),
        Card(
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.network(
              model.imageUrl,
              fit: BoxFit.contain,
              height: heightFactor * 0.3,
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
                return const Icon(Icons.broken_image, size: 80);
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
