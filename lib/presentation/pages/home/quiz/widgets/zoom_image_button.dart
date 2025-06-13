import 'package:cdl_pro/presentation/blocs/road_sign_bloc/road_sign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ZoomImageButton extends StatelessWidget {
  const ZoomImageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RoadSignBloc>();

    return BlocBuilder<RoadSignBloc, AbstractRoadSignState>(
      builder: (context, state) {
        if (state is! RoadSignState) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.zoom_out),
                onPressed: () => bloc.add(ZoomOutEvent()),
                tooltip: 'Уменьшить изображения',
              ),
              Text('Размер: ${(state.imageHeightFactor * 100).toInt()}%'),
              IconButton(
                icon: const Icon(Icons.zoom_in),
                onPressed: () => bloc.add(ZoomInEvent()),
                tooltip: 'Увеличить изображения',
              ),
            ],
          ),
        );
      },
    );
  }
}
