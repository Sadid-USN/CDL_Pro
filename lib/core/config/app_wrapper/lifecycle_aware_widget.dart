import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class LifecycleAwareWidget extends StatefulWidget {
  final Widget child;

  const LifecycleAwareWidget({super.key, required this.child});

  @override
  State<LifecycleAwareWidget> createState() => _LifecycleAwareWidgetState();
}

class _LifecycleAwareWidgetState extends State<LifecycleAwareWidget>
    with WidgetsBindingObserver {
  bool _isVisible = true;
  late final Talker _talker;

  @override
  void initState() {
    super.initState();
    _talker = GetIt.I<Talker>();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _talker.info(switch (state) {
      AppLifecycleState.resumed => '✅ App is visible (resumed)',
      AppLifecycleState.paused => '⏸️ App is backgrounded (paused)',
      _ => null,
    });

    setState(() {
      _isVisible = state == AppLifecycleState.resumed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isVisible ? widget.child : const SizedBox.shrink();
  }
}
