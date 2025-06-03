import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'package:cdl_pro/presentation/pages/home/home.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

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
    final bloc = context.read<CDLTestsBloc>();
    final initialLanguage =
        bloc.state is QuizLoadedState
            ? (bloc.state as QuizLoadedState).selectedLanguage
            : 'en';

    bloc.add(LoadQuizEvent(questions, initialLanguage: initialLanguage));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '$chapterTitle (${startIndex + context.read<CDLTestsBloc>().currentPage} / ${questions.length})',
            style: AppTextStyles.manrope10,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => _showExitConfirmation(context),
          ),
        ),
        body: BlocBuilder<CDLTestsBloc, AbstractCDLTestsState>(
          builder: (context, state) {
            if (state is QuizLoadedState) {
              return SingleQuestionView(
                state: state,
                chapterTitle: chapterTitle,
                questions: questions,
                startIndex: startIndex,
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
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
                title: Text(LocaleKeys.confirm.tr()),
                content: Text(LocaleKeys.areYouSureYouWantToExit.tr()),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: Text(LocaleKeys.no.tr()),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    child: Text(LocaleKeys.yes.tr()),
                  ),
                ],
              ),
        ) ??
        false;

    if (shouldExit && context.mounted) {
      context.router.pop();
    }
  }
}

class SingleQuestionView extends StatelessWidget {
  final QuizLoadedState state;
  final String chapterTitle;
  final List<Question> questions;
  final int startIndex;

  const SingleQuestionView({
    super.key,
    required this.state,
    required this.chapterTitle,
    required this.questions,
    required this.startIndex,
  });

  @override
  Widget build(BuildContext context) {
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
            child: QuestionCard(
              selectedLanguage: state.selectedLanguage,
              question: currentQuestion,
              questionNumber: questionNumber,
              isAnswered: isAnswered,
              userAnswer: userAnswer,
              isCorrect: isCorrect,
              allQuestions: state.allQuestions,
              userAnswers: state.userAnswers,
            ),
          ),
        ),
        if (isAnswered)
          NextQuestionButton(
            isLastQuestion: state.currentPage == state.allQuestions.length - 1,
          ),
      ],
    );
  }
}

class QuestionCard extends StatelessWidget {
  final Question question;
  final int questionNumber;
  final bool isAnswered;
  final String? userAnswer;
  final bool isCorrect;
  final List<Question> allQuestions;
  final Map<String, String> userAnswers;
  final String selectedLanguage;

  const QuestionCard({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.isAnswered,
    required this.userAnswer,
    required this.isCorrect,
    required this.allQuestions,
    required this.userAnswers,
    required this.selectedLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final correctCount =
        allQuestions
            .where((q) => userAnswers[q.question] == q.correctOption)
            .length;
    final incorrectCount = userAnswers.length - correctCount;
    final bloc = context.read<CDLTestsBloc>();
    return Card(
      color: AppColors.lightBackground,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.question.tr(
                    namedArgs: {"questionNumber": questionNumber.toString()},
                  ),
                  style: AppTextStyles.robotoMonoBold14,
                ),
                TranslationButton(
                  initialLanguage: selectedLanguage,
                  onLanguageChanged: (lang) {
                    bloc.add(ChangeLanguageEvent(lang));
                  },
                ),
              ],
            ),
            // Text(
            //   LocaleKeys.question.tr(
            //     namedArgs: {"questionNumber": questionNumber.toString()},
            //   ),
            //   style: AppTextStyles.robotoMonoBold14,
            // ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '$questionNumber ${LocaleKeys.outOf.tr()} ${allQuestions.length} /',
                  style: AppTextStyles.robotoMonoBold14,
                ),
                const SizedBox(width: 4),
                Text(
                  '$incorrectCount',
                  style: AppTextStyles.robotoMonoBold14.copyWith(
                    color: Colors.red,
                  ),
                ),
                const Text(' / '),
                Text(
                  '$correctCount',
                  style: AppTextStyles.robotoMonoBold14.copyWith(
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            FutureBuilder<String>(
              future:
                  selectedLanguage.isNotEmpty && selectedLanguage != 'en'
                      ? bloc.translateText(question.question, selectedLanguage)
                      : Future.value(question.question),
              builder: (context, snapshot) {
                return Text(
                  snapshot.data ?? question.question,
                  style: AppTextStyles.regular16,
                );
              },
            ),
            SizedBox(height: 16.h),
            ...QuestionOptions.buildOptions(
              context,
              question,
              isAnswered,
              userAnswer,
              isCorrect,
              selectedLanguage,
            ),
            if (isAnswered) ...[
              const SizedBox(height: 16),
              if (isAnswered) ...[
                const SizedBox(height: 16),
                FutureBuilder<String>(
                  future:
                      selectedLanguage !=
                              'en' // Упрощаем условие
                          ? bloc.translateText(
                            question.description,
                            selectedLanguage,
                          )
                          : Future.value(question.description),
                  builder: (context, snapshot) {
                    return Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(LocaleKeys.explanation.tr(),),
                        Text(
                          snapshot.data ?? question.description ,
                          style: AppTextStyles.manrope14,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class QuestionOptions extends StatelessWidget {
  final Question question;
  final bool isAnswered;
  final String? userAnswer;
  final bool isCorrect;
  final String selectedLanguage;

  const QuestionOptions({
    super.key,
    required this.question,
    required this.isAnswered,
    required this.userAnswer,
    required this.isCorrect,
    required this.selectedLanguage,
  });

  static List<Widget> buildOptions(
    BuildContext context,
    Question question,
    bool isAnswered,
    String? userAnswer,
    bool isCorrect,
    String selectedLanguage, // Добавляем параметр языка
  ) {
    final bloc = context.read<CDLTestsBloc>();

    return question.options.entries.map((entry) {
      final optionKey = entry.key;
      final optionText = entry.value;
      final isSelected = userAnswer == optionKey;
      final isCorrectOption = optionKey == question.correctOption;

      Color backgroundColor = Colors.white;
      Color textColor = Colors.black;
      Color? iconColor;

      if (isAnswered) {
        if (isCorrectOption) {
          backgroundColor = AppColors.greenSoft;
          textColor = AppColors.darkBackground;
          iconColor = AppColors.simpleGreen;
        } else if (isSelected) {
          backgroundColor = AppColors.errorColor.withValues(alpha: 0.4);
          textColor = AppColors.darkBackground;
          iconColor = AppColors.errorColor;
        }
      }

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
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text('$optionKey. ', style: TextStyle(color: textColor)),
                Expanded(
                  child: FutureBuilder<String>(
                    future:
                        selectedLanguage.isNotEmpty && selectedLanguage != 'en'
                            ? bloc.translateText(optionText, selectedLanguage)
                            : Future.value(optionText),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ?? optionText,
                        style: TextStyle(color: textColor),
                      );
                    },
                  ),
                ),
                if (isAnswered && (isSelected || isCorrectOption))
                  SvgPicture.asset(
                    isCorrectOption ? AppLogos.correct : AppLogos.wrong,
                    height: 20.h,
                    colorFilter:
                        iconColor != null
                            ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                            : null,
                  ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: buildOptions(
        context,
        question,
        isAnswered,
        userAnswer,
        isCorrect,
        selectedLanguage,
      ),
    );
  }
}

class NextQuestionButton extends StatelessWidget {
  final bool isLastQuestion;

  const NextQuestionButton({super.key, required this.isLastQuestion});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 50.h),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(),
        onPressed: () {
          if (isLastQuestion) {
            Navigator.of(context).pop();
          } else {
            context.read<CDLTestsBloc>().add(const NextQuestionsEvent());
          }
        },
        child: Text(
          isLastQuestion
              ? LocaleKeys.completeTheTest.tr()
              : LocaleKeys.nextQuestion.tr(),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

// class QuizHeaderBuilder {
//   static InlineSpan build({
//     required String chapterTitle,
//     required int currentIndex,
//     required int totalQuestions,
//     required int incorrectAnswers,
//   }) {
//     return TextSpan(
//       style: AppTextStyles.manrope10, // Базовый стиль
//       children: [
//         TextSpan(
//           text: chapterTitle,
//           style: AppTextStyles.manrope10.copyWith(fontWeight: FontWeight.bold),
//         ),
//         const TextSpan(text: ' (Вопрос '),
//         TextSpan(
//           text: '${currentIndex + 1}',
//           style: AppTextStyles.manrope10.copyWith(fontWeight: FontWeight.w600),
//         ),
//         TextSpan(text: ' из $totalQuestions', style: AppTextStyles.manrope10),
//         const TextSpan(text: ') • Ошибки: '),
//         TextSpan(
//           text: '$incorrectAnswers',
//           style: AppTextStyles.manrope10.copyWith(
//             color: Colors.red,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         TextSpan(
//           text: '/$totalQuestions',
//           style: AppTextStyles.manrope10.copyWith(fontWeight: FontWeight.w500),
//         ),
//       ],
//     );
//   }
// }
