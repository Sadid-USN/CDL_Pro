import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/presentation/blocs/settings_bloc/settings.dart';
import 'package:cdl_pro/presentation/pages/home/views/views.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

@RoutePage()
class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  /// Метод для отображения названия в AppBar
  String getCollectionTitle(AppDataType type) {
    switch (type) {
      case AppDataType.cdlTests:
        return 'CDLTests';
      case AppDataType.roadSign:
        return 'RoadSign';
      case AppDataType.tripInseption:
        return 'PreTripInseption';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            return Center(
              child: Text('No data $stream'),
            );
          }

          return StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return  Center(
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
                case AppDataType.roadSign:
                  return RoadSignView(docs: docs);
                case AppDataType.tripInseption:
                  return PreTripInspectionView(docs: docs);
              }
            },
          );
        },
      ),
    );
  }
}
