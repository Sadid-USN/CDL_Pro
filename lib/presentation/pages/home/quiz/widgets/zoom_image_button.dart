// import 'package:cdl_pro/core/core.dart';
// import 'package:cdl_pro/generated/locale_keys.g.dart';
// import 'package:cdl_pro/presentation/blocs/road_sign_bloc/road_sign.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ZoomImageButton extends StatelessWidget {
//   const ZoomImageButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final bloc = context.read<RoadSignBloc>();

//     return BlocBuilder<RoadSignBloc, RoadSignState>(
//       builder: (context, state) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.zoom_out, color: AppColors.lightPrimary,),
//                 onPressed: () => bloc.add(ZoomOutEvent()),
//                 tooltip: '',
//               ),
//               Text('${LocaleKeys.size.tr()}: ${(state.imageHeightFactor * 100).toInt()}%'),
//               IconButton(
//                 icon: const Icon(Icons.zoom_in, color: AppColors.lightPrimary,),
//                 onPressed: () => bloc.add(ZoomInEvent()),
//                 tooltip: '',
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
