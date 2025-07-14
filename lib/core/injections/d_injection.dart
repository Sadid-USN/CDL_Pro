import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/data/impl/impl.dart';
import 'package:cdl_pro/domain/domain.dart';
import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'package:cdl_pro/presentation/blocs/profile_bloc/profile.dart';
import 'package:cdl_pro/presentation/blocs/purchase/purchase.dart';
import 'package:cdl_pro/presentation/blocs/road_sign_bloc/road_sign_bloc.dart';
import 'package:cdl_pro/presentation/blocs/settings_bloc/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_settings.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  /* ───────────────  INIT TALKER & LOCALIZATION  ─────────────── */
  final talker = TalkerFlutter.init(
    settings: TalkerSettings(
      enabled: true,
      useConsoleLogs: true,
      maxHistoryItems: 100,
    ),
  );
  getIt.registerSingleton<Talker>(talker);

  await EasyLocalization.ensureInitialized();

  /* ───────────────  FIREBASE CORE  ─────────────── */
  await Firebase.initializeApp();
  // if (Platform.isAndroid) {
  //   await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //       apiKey: 'AIzaSyDnJscXti1wBxSWB8LZojTf20NZFb5NO1w',
  //       appId: '1:899513564439:android:8e5c83dff1c340b34a4b52',
  //       messagingSenderId: '899513564439',
  //       projectId: 'cdl-pro-cb12c',
  //     ),
  //   );
  // } else {
  //   await Firebase.initializeApp();
  // }

  /* ───────────────  DIO (пример)  ─────────────── */
  final dio = Dio();
  dio.interceptors.add(
    TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printResponseHeaders: true,
        printResponseMessage: true,
        printResponseData: false,
      ),
    ),
  );

  /* ───────────────  Flutter Error Hook  ─────────────── */
  FlutterError.onError =
      (details) => getIt<Talker>().handle(details.exception, details.stack);

  /* ───────────────  GLOBAL BLoC OBSERVER  ─────────────── */
  Bloc.observer = TalkerBlocObserver(
    talker: talker,
    settings: const TalkerBlocLoggerSettings(
      printStateFullData: false,
      printEventFullData: false,
    ),
  );

  /* ───────────────  CORE SINGLETONS  ─────────────── */
  // 1. SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // 2. DatabaseHelper
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.database; // Инициализируем базу данных
  getIt.registerSingleton<DatabaseHelper>(dbHelper);

  // 3. Firestore
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // 3. UserRepository (абстракция → реализация)
  getIt.registerLazySingleton<AbstractUserRepo>(
    () => UserRepositoryImpl(FirebaseAuth.instance),
  );
  // 3. SecureStorage
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  // 4. AuthService (🔑 должен идти ПЕРЕД ProfileBloc!)
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(
      auth: FirebaseAuth.instance,
      firestore: getIt<FirebaseFirestore>(),
      storage: getIt<SecureStorageService>(),
    ),
  );

  /* ───────────────  UserHolder─────────────── */
  getIt.registerLazySingleton<UserHolder>(() => UserHolder());

  /* ───────────────  APPLICATION BLoC’и / сервисы  ─────────────── */
  getIt.registerLazySingleton<SettingsBloc>(() => SettingsBloc());

  getIt.registerLazySingleton<PurchaseBloc>(
    () =>
        PurchaseBloc()
          ..add(InitializePurchase())
          ..add(CheckPastPurchases()),
  );

  getIt.registerLazySingleton<RoadSignBloc>(() => RoadSignBloc([]));

  getIt.registerLazySingleton<ProfileBloc>(
    () => ProfileBloc(initializeOnCreate: true, prefs: prefs),
  );
  // 4. CDLTestsBloc — регистрируем ПОСЛЕ всех его зависимостей
  getIt.registerLazySingleton<CDLTestsBloc>(
    () => CDLTestsBloc(
      getIt<SharedPreferences>(),
      getIt<FirebaseFirestore>(),
      getIt<UserHolder>(),
    ),
  );
}
