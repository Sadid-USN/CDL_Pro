import 'package:cdl_pro/presentation/blocs/settings_bloc/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsBloc extends Bloc<AbstractSettingsEvent, SettingsState> {
  final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
  late SharedPreferences prefs;

  SettingsBloc() : super(SettingsState.initial()) {
    add(InitializeSettings());
  }
}
