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
/// [ImagesPage]
class ImagesRoute extends PageRouteInfo<ImagesRouteArgs> {
  ImagesRoute({
    Key? key,
    required List<String> imageUrls,
    List<PageRouteInfo>? children,
  }) : super(
         ImagesRoute.name,
         args: ImagesRouteArgs(key: key, imageUrls: imageUrls),
         initialChildren: children,
       );

  static const String name = 'ImagesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ImagesRouteArgs>();
      return ImagesPage(key: args.key, imageUrls: args.imageUrls);
    },
  );
}

class ImagesRouteArgs {
  const ImagesRouteArgs({this.key, required this.imageUrls});

  final Key? key;

  final List<String> imageUrls;

  @override
  String toString() {
    return 'ImagesRouteArgs{key: $key, imageUrls: $imageUrls}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ImagesRouteArgs) return false;
    return key == other.key &&
        const ListEquality().equals(imageUrls, other.imageUrls);
  }

  @override
  int get hashCode => key.hashCode ^ const ListEquality().hash(imageUrls);
}

/// generated route for
/// [InitialPage]
class InitialRoute extends PageRouteInfo<void> {
  const InitialRoute({List<PageRouteInfo>? children})
    : super(InitialRoute.name, initialChildren: children);

  static const String name = 'InitialRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const InitialPage();
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
/// [OnBoardingPage]
class OnBoardingRoute extends PageRouteInfo<void> {
  const OnBoardingRoute({List<PageRouteInfo>? children})
    : super(OnBoardingRoute.name, initialChildren: children);

  static const String name = 'OnBoardingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnBoardingPage();
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OverviewCategoryRouteArgs) return false;
    return key == other.key &&
        categoryKey == other.categoryKey &&
        model == other.model;
  }

  @override
  int get hashCode => key.hashCode ^ categoryKey.hashCode ^ model.hashCode;
}

/// generated route for
/// [PolicyPage]
class PolicyRoute extends PageRouteInfo<PolicyRouteArgs> {
  PolicyRoute({
    Key? key,
    required PolicyType type,
    List<PageRouteInfo>? children,
  }) : super(
         PolicyRoute.name,
         args: PolicyRouteArgs(key: key, type: type),
         initialChildren: children,
       );

  static const String name = 'PolicyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PolicyRouteArgs>();
      return PolicyPage(key: args.key, type: args.type);
    },
  );
}

class PolicyRouteArgs {
  const PolicyRouteArgs({this.key, required this.type});

  final Key? key;

  final PolicyType type;

  @override
  String toString() {
    return 'PolicyRouteArgs{key: $key, type: $type}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PolicyRouteArgs) return false;
    return key == other.key && type == other.type;
  }

  @override
  int get hashCode => key.hashCode ^ type.hashCode;
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
    required String categoryKey,
    required TestsDataModel model,
    List<PageRouteInfo>? children,
  }) : super(
         QuizRoute.name,
         args: QuizRouteArgs(
           key: key,
           chapterTitle: chapterTitle,
           questions: questions,
           startIndex: startIndex,
           categoryKey: categoryKey,
           model: model,
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
        categoryKey: args.categoryKey,
        model: args.model,
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
    required this.categoryKey,
    required this.model,
  });

  final Key? key;

  final String chapterTitle;

  final List<Question> questions;

  final int startIndex;

  final String categoryKey;

  final TestsDataModel model;

  @override
  String toString() {
    return 'QuizRouteArgs{key: $key, chapterTitle: $chapterTitle, questions: $questions, startIndex: $startIndex, categoryKey: $categoryKey, model: $model}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! QuizRouteArgs) return false;
    return key == other.key &&
        chapterTitle == other.chapterTitle &&
        const ListEquality().equals(questions, other.questions) &&
        startIndex == other.startIndex &&
        categoryKey == other.categoryKey &&
        model == other.model;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      chapterTitle.hashCode ^
      const ListEquality().hash(questions) ^
      startIndex.hashCode ^
      categoryKey.hashCode ^
      model.hashCode;
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

/// generated route for
/// [SignUpPage]
class SignUpRoute extends PageRouteInfo<void> {
  const SignUpRoute({List<PageRouteInfo>? children})
    : super(SignUpRoute.name, initialChildren: children);

  static const String name = 'SignUpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignUpPage();
    },
  );
}
