import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class QuizPage extends StatelessWidget {
  final String chapterTitle;
  final List<Question> questions;
  final int startIndex;

  const QuizPage({
    super.key,
    required this.chapterTitle,
    required this.questions,
    required this.startIndex,
  });

  @override
  Widget build(BuildContext context) {
    context.read<CDLTestsBloc>().add(LoadQuizEvent(questions));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Обработка случая, когда выход не был успешным.
          return;
        }
        // Логика при успешном закрытии страницы.
        print("Page popped with result: $result");
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '$chapterTitle (${startIndex + context.read<CDLTestsBloc>().currentPage} / ${questions.length})',
            style: AppTextStyles.manrope10,
          ),

          //            RichText(
          //   text:
          //   QuizHeaderBuilder.build(
          //     chapterTitle: widget.chapterTitle,
          //     currentIndex: widget.startIndex + context.read<CDLTestsBloc>().currentPage,
          //     totalQuestions: widget.questions.length,
          //     incorrectAnswers: 2,
          //   ),
          // ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              //context.router.pop();
              _showExitConfirmation(context);
            },
          ),
        ),
        body: BlocBuilder<CDLTestsBloc, AbstractCDLTestsState>(
          builder: (context, state) {
            if (state is QuizLoadedState) {
              return _buildSingleQuestionView(context, state);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildSingleQuestionView(BuildContext context, QuizLoadedState state) {
    final currentQuestion = state.allQuestions[state.currentPage];
    final questionNumber = state.currentPage + 1;
    final userAnswer = state.userAnswers[currentQuestion.question];
    final isAnswered = userAnswer != null;
    final isCorrect = isAnswered && userAnswer == currentQuestion.correctOption;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildQuestionCard(
              context,
              question: currentQuestion,
              questionNumber: questionNumber,
              isAnswered: isAnswered,
              userAnswer: userAnswer,
              isCorrect: isCorrect,
            ),
          ),
        ),
        if (isAnswered) _buildNextButton(context, state),
      ],
    );
  }

  Widget _buildQuestionCard(
    BuildContext context, {
    required Question question,
    required int questionNumber,
    required bool isAnswered,
    required String? userAnswer,
    required bool isCorrect,
  }) {
    // final cardColor = isAnswered
    //     ? (isCorrect ? Colors.green.shade100 : Colors.red)
    //     : Colors.white;

    return Card(
      color: AppColors.lightBackground,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Вопрос #$questionNumber',
              style: AppTextStyles.robotoMonoBold14,
            ),
            const SizedBox(height: 8),
            Text(question.question, style: AppTextStyles.regular16),
            const SizedBox(height: 16),
            ..._buildQuestionOptions(
              context,
              question,
              isAnswered,
              userAnswer,
              isCorrect,
            ),
            if (isAnswered) ...[
              const SizedBox(height: 16),
              Text(
                'Объяснение: ${question.description}',
                style: AppTextStyles.manrope14,
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildQuestionOptions(
    BuildContext context,
    Question question,
    bool isAnswered,
    String? userAnswer,
    bool isCorrect,
  ) {
    return question.options.entries.map((entry) {
      final optionKey = entry.key;
      final optionText = entry.value;
      final isSelected = userAnswer == optionKey;
      final isCorrectOption = optionKey == question.correctOption;

      final color =
          isAnswered
              ? (isCorrectOption
                  ? Colors.green
                  : (isSelected ? Colors.red : Colors.black))
              : Colors.black;

      return InkWell(
        onTap:
            !isAnswered
                ? () => context.read<CDLTestsBloc>().add(
                  AnswerQuestionEvent(question.question, optionKey),
                )
                : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? color : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text(
                  '$optionKey. ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Text(
                    optionText,
                    style: TextStyle(color: color, fontSize: 16),
                  ),
                ),
                if (isSelected)
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: color,
                  ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildNextButton(BuildContext context, QuizLoadedState state) {
    final isLastQuestion = state.currentPage == state.allQuestions.length - 1;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: () {
          if (isLastQuestion) {
            Navigator.of(context).pop();
          } else {
            context.read<CDLTestsBloc>().add(const NextQuestionsEvent());
          }
        },
        child: Text(
          isLastQuestion ? 'Завершить тест' : 'Следующий вопрос',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _showExitConfirmation(BuildContext context) async {
    final shouldExit =
        await showDialog<bool>(
          context: context,
          builder:
              (dialogContext) => AlertDialog(
                title: const Text('Подтверждение'),
                content: const Text(
                  'Вы уверены, что хотите выйти? Прогресс будет потерян.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: const Text('Нет'),
                  ),
                  TextButton(
                    onPressed: () {
                      // 👇 Закрываем диалог, возвращая true
                      Navigator.of(dialogContext).pop(true);
                    },
                    child: const Text('Да'),
                  ),
                ],
              ),
        ) ??
        false;

    if (shouldExit && context.mounted) {
      // 👇 Только теперь — закрываем QuizPage
      context.router.pop();
    }
  }
}

class QuizHeaderBuilder {
  static InlineSpan build({
    required String chapterTitle,
    required int currentIndex,
    required int totalQuestions,
    required int incorrectAnswers,
  }) {
    return TextSpan(
      style: AppTextStyles.manrope10, // Базовый стиль
      children: [
        TextSpan(
          text: chapterTitle,
          style: AppTextStyles.manrope10.copyWith(fontWeight: FontWeight.bold),
        ),
        const TextSpan(text: ' (Вопрос '),
        TextSpan(
          text: '${currentIndex + 1}',
          style: AppTextStyles.manrope10.copyWith(fontWeight: FontWeight.w600),
        ),
        TextSpan(text: ' из $totalQuestions', style: AppTextStyles.manrope10),
        const TextSpan(text: ') • Ошибки: '),
        TextSpan(
          text: '$incorrectAnswers',
          style: AppTextStyles.manrope10.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: '/$totalQuestions',
          style: AppTextStyles.manrope10.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
