import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
@RoutePage()
class QuizPage extends StatelessWidget {
  const QuizPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('title'), centerTitle: true),
      body: Column(children: []),
    );
  }
}
