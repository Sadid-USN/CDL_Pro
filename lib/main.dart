import 'dart:async';
import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/presentation/blocs/profile_bloc/profile.dart';
import 'package:cdl_pro/presentation/blocs/purchase/purchase.dart';
import 'package:cdl_pro/presentation/blocs/road_sign_bloc/road_sign_bloc.dart';
import 'package:cdl_pro/router/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'core/config/app_wrapper/localization_wrapper.dart';
import 'presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'presentation/blocs/settings_bloc/settings.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      await initDependencies();

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]).then((_) {
        runApp(LocalizationWrapper(child: MyApp()));
        FlutterNativeSplash.remove();
      });
    },
    (error, stack) {
      return GetIt.I<Talker>().handle(error, stack);
    },
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _autorouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(
          create: (context) => GetIt.I<SettingsBloc>(),
        ),
        BlocProvider<CDLTestsBloc>(
          create: (context) => GetIt.I<CDLTestsBloc>(),
        ),
        BlocProvider<RoadSignBloc>(
          create: (context) => GetIt.I<RoadSignBloc>(),
        ),
        BlocProvider<ProfileBloc>(create: (context) => GetIt.I<ProfileBloc>()),
        BlocProvider<PurchaseBloc>(create: (_) => GetIt.I<PurchaseBloc>()),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return BlocListener<ProfileBloc, ProfileState>(
            listenWhen: (prev, curr) => prev.user?.uid != curr.user?.uid,
            listener: (context, state) {
              GetIt.I<UserHolder>().setUid(state.user?.uid);
            },
            child: ScreenUtilInit(
              minTextAdapt: true,
              builder: (context, child) {
                return MaterialApp.router(
                  theme: lightThemeData(),
                  darkTheme: darkThemeData(),
                  themeMode:
                      state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  debugShowCheckedModeBanner: false,
                  title: 'CDL_pro',
                  routerConfig: _autorouter.config(
                    navigatorObservers:
                        () => [TalkerRouteObserver(GetIt.I<Talker>())],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
