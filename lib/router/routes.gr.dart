// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'routes.dart';

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [MainCategoryPage]
class MainCategoryRoute extends PageRouteInfo<void> {
  const MainCategoryRoute({List<PageRouteInfo>? children})
    : super(MainCategoryRoute.name, initialChildren: children);

  static const String name = 'MainCategoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainCategoryPage();
    },
  );
}

/// generated route for
/// [MainPage]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainPage();
    },
  );
}

/// generated route for
/// [OverviewCategoryPage]
class OverviewCategoryRoute extends PageRouteInfo<OverviewCategoryRouteArgs> {
  OverviewCategoryRoute({
    Key? key,
    required String? categoryKey,
    required TestsDataModel? model,
    List<PageRouteInfo>? children,
  }) : super(
         OverviewCategoryRoute.name,
         args: OverviewCategoryRouteArgs(
           key: key,
           categoryKey: categoryKey,
           model: model,
         ),
         initialChildren: children,
       );

  static const String name = 'OverviewCategoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OverviewCategoryRouteArgs>();
      return OverviewCategoryPage(
        key: args.key,
        categoryKey: args.categoryKey,
        model: args.model,
      );
    },
  );
}

class OverviewCategoryRouteArgs {
  const OverviewCategoryRouteArgs({
    this.key,
    required this.categoryKey,
    required this.model,
  });

  final Key? key;

  final String? categoryKey;

  final TestsDataModel? model;

  @override
  String toString() {
    return 'OverviewCategoryRouteArgs{key: $key, categoryKey: $categoryKey, model: $model}';
  }
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfilePage();
    },
  );
}

/// generated route for
/// [QuizPage]
class QuizRoute extends PageRouteInfo<QuizRouteArgs> {
  QuizRoute({
    Key? key,
    required String chapterTitle,
    required List<Question> questions,
    required int startIndex,
    List<PageRouteInfo>? children,
  }) : super(
         QuizRoute.name,
         args: QuizRouteArgs(
           key: key,
           chapterTitle: chapterTitle,
           questions: questions,
           startIndex: startIndex,
         ),
         initialChildren: children,
       );

  static const String name = 'QuizRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<QuizRouteArgs>();
      return QuizPage(
        key: args.key,
        chapterTitle: args.chapterTitle,
        questions: args.questions,
        startIndex: args.startIndex,
      );
    },
  );
}

class QuizRouteArgs {
  const QuizRouteArgs({
    this.key,
    required this.chapterTitle,
    required this.questions,
    required this.startIndex,
  });

  final Key? key;

  final String chapterTitle;

  final List<Question> questions;

  final int startIndex;

  @override
  String toString() {
    return 'QuizRouteArgs{key: $key, chapterTitle: $chapterTitle, questions: $questions, startIndex: $startIndex}';
  }
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsPage();
    },
  );
}
