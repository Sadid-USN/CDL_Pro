import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/core/config/app_wrapper/lifecycle_aware_widget.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/presentation/blocs/settings_bloc/settings.dart';
import 'package:cdl_pro/presentation/pages/home/quiz/views/views.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

@RoutePage()
class MainCategoryPage extends StatelessWidget {
  const MainCategoryPage({super.key});

  /// Метод для отображения названия в AppBar
  String getCollectionTitle(AppDataType type) {
    switch (type) {
      case AppDataType.cdlTests:
        return 'CDLTests';
      case AppDataType.cdlTestsRu:
        return 'CDLTestsRu';
      case AppDataType.cdlTestsUk:
        return 'CDLTestsUk';
      case AppDataType.cdlTestsEs:
        return 'CDLTestsSp';
      case AppDataType.roadSign:
        return 'RoadSign';
      case AppDataType.tripInseption:
        return 'PreTripInseption';
      case AppDataType.termsOfUse:
        return 'termsOfUse';
      case AppDataType.privacyPolicy:
        return 'privacyPolicy';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
           context.router.pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return Text(
              getCollectionTitle(state.selectedType),
              style: Theme.of(context).textTheme.bodyLarge,
            );
          },
        ),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final stream = state.collectionStream;

          if (stream == null) {
            return Center(child: Text('No data $stream'));
          }

          return StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: LottieBuilder.asset(
                    'assets/lottie/truck_loader.json',
                    height: 100,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No data found"));
              }

              final docs = snapshot.data!.docs;

              switch (state.selectedType) {
                case AppDataType.cdlTests:
                  return CDLTestsView(docs: docs);
                case AppDataType.cdlTestsRu:
                  return CDLTestsView(docs: docs);
                case AppDataType.cdlTestsUk:
                  return CDLTestsView(docs: docs);
                case AppDataType.cdlTestsEs:
                  return CDLTestsView(docs: docs);
                case AppDataType.roadSign:
                  return RoadSignView(docs: docs);
                case AppDataType.tripInseption:
                  return PreTripInspectionView(docs: docs);
                case AppDataType.termsOfUse:
                  return PreTripInspectionView(docs: docs);
                case AppDataType.privacyPolicy:
                  return PreTripInspectionView(docs: docs);
              }
            },
          );
        },
      ),
    );
  }
}
