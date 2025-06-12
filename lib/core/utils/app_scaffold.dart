import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
class AppScaffold extends StatelessWidget {
  /// set if appbar is null
  final String? title;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final bool Function(BuildContext context)? isLoadingFunc;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? scaffoldBackground;

  /// set [scaffoldKey] if setting drawer
  final Widget? drawer;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  /// pop current page or not when native back button pressed
  final bool? canPop;

  /// Bottom navigation bar
  final Widget? bottomNavigationBar;

  const AppScaffold({
    required this.body,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
    this.appBar,
    this.title,
    this.isLoadingFunc,
    this.scaffoldBackground,
    this.drawer,
    this.scaffoldKey,
    this.canPop,
    this.bottomNavigationBar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop ?? context.router.canPop(),
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Обработка случая, когда выход не был успешным.
          return;
        }
        // Логика при успешном закрытии страницы.
        print("Page popped with result: $result");
      },
      child: Stack(
        children: [
          Scaffold(
            
            key: scaffoldKey,
            appBar: _buildAppBar(),
            drawer: drawer,
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: floatingActionButtonLocation,
            extendBodyBehindAppBar: extendBodyBehindAppBar,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            backgroundColor:
                scaffoldBackground ?? context.colorScheme.surface,
            body: body,
            bottomNavigationBar: bottomNavigationBar,
          ),
          Visibility(
            visible: isLoadingFunc?.call(context) ?? false,
            child: const Center(child: CircularProgressIndicator(),),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    if (appBar != null) {
      return appBar;
    }
    if (title != null) {
      return AppBar(
        title: Text(title!),
      );
    }
    return null;
  }
}
