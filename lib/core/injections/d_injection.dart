import 'dart:io';
import 'package:cdl_pro/core/constants/constants.dart';
import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'package:cdl_pro/presentation/blocs/profile_bloc/profile.dart';
import 'package:cdl_pro/presentation/blocs/road_sign_bloc/road_sign_bloc.dart';
import 'package:cdl_pro/presentation/blocs/settings_bloc/settings.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_settings.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  final talker = TalkerFlutter.init(
    settings: TalkerSettings(
      enabled: true,
      useConsoleLogs: true,
      maxHistoryItems: 100,
    ),
  );
  GetIt.I.registerSingleton(talker);
  await EasyLocalization.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDnJscXti1wBxSWB8LZojTf20NZFb5NO1w',
        appId: '1:899513564439:android:8e5c83dff1c340b34a4b52',
        messagingSenderId: '899513564439',
        projectId: 'cdl-pro-cb12c',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  final dio = Dio();
  // interceptors Получает информацию о любом запросе, который производит клиент Dio
  dio.interceptors.add(
    TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printResponseData: false,
        printRequestHeaders: true,
        printResponseHeaders: true,
        printResponseMessage: true,
      ),
    ),
  );
  Gemini.init(apiKey: AppTitles.gemeniApiKey);
  FlutterError.onError =
      (details) => GetIt.I<Talker>().handle(details.exception, details.stack);

  Bloc.observer = TalkerBlocObserver(
    talker: talker,
    settings: const TalkerBlocLoggerSettings(
      printStateFullData: false,
      printEventFullData: false,
    ),
  );

  // ✅ Регистрируем API сервис для запросов к молитвенным временам
  // GetIt.I.registerLazySingleton(() => PrayerTimeApi(dio: dio));

  // ✅ Регистрируем сервис геолокации
  //GetIt.I.registerLazySingleton(() => LocationGeolocatorService());

  // ✅ Регистрируем PrayerTimeImpl и передаем в него зависимости
  // GetIt.I.registerLazySingleton(
  //   () => PrayerTimeImpl(
  //     prayerTimeApi: GetIt.I<PrayerTimeApi>(),
  //     locationService: GetIt.I<LocationGeolocatorService>(),
  //     // locationIpInfoService: LocationIpInfoService(dio: dio),

  //   ),
  // );
  GetIt.I.registerLazySingleton(() => SettingsBloc());
  GetIt.I.registerLazySingleton(() => RoadSignBloc([]));

  GetIt.I.registerLazySingleton(() => CDLTestsBloc(prefs));
  GetIt.I.registerLazySingleton<ProfileBloc>(
    () => ProfileBloc(initializeOnCreate: true),
  );
}
