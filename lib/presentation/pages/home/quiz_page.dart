import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'package:cdl_pro/router/routes.dart';
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
  final String categoryKey; // Добавляем параметр для возврата
  final TestsDataModel model; // Добавляем параметр для возврата

  const QuizPage({
    super.key,
    required this.chapterTitle,
    required this.questions,
    required this.startIndex,
    required this.categoryKey,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CDLTestsBloc>();
    bloc.add(LoadQuizEvent(questions, initialLanguage: 'en'));

    return _QuizPageContent(
      model: model,
      categoryKey: categoryKey,
      chapterTitle: chapterTitle,
      questions: questions,
      startIndex: startIndex,
    );
  }
}

class _QuizPageContent extends StatelessWidget {
  final String chapterTitle;
  final List<Question> questions;
  final int startIndex;
  final String categoryKey;
  final TestsDataModel model;

  const _QuizPageContent({
    required this.chapterTitle,
    required this.questions,
    required this.startIndex,
    required this.categoryKey,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CDLTestsBloc, AbstractCDLTestsState>(
      listener: (context, state) {
        if (state is QuizLoadedState) {
          context.read<CDLTestsBloc>().add(SaveQuizProgressEvent());
        }
      },
      builder: (context, state) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) async {
                if (!didPop) {
                  await context.read<CDLTestsBloc>().saveProgress();
                }
              },
              child: Scaffold(
                appBar: AppBar(
                  title: _buildAppBarTitle(state),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => _showExitConfirmation(context),
                  ),
                ),
                body: _buildBody(state),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAppBarTitle(AbstractCDLTestsState state) {
    if (state is QuizLoadedState) {
      return Text(chapterTitle, style: AppTextStyles.merriweatherBold14);
    }
    return Text(chapterTitle, style: AppTextStyles.manropeBold14);
  }

  Widget _buildBody(AbstractCDLTestsState state) {
    if (state is QuizLoadedState) {
      return SingleQuestionView(
        key: ValueKey(state.currentPage),
        state: state,
        chapterTitle: chapterTitle,
        questions: questions,
        startIndex: startIndex,
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              LocaleKeys.exit.tr(),
              style: AppTextStyles.merriweatherBold14,
            ),
            content: Text(LocaleKeys.areYouSureYouWantToExit.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(LocaleKeys.no.tr()),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(LocaleKeys.yes.tr()),
              ),
            ],
          ),
    );

    if (result == true && context.mounted) {
      // Используем navigateToPage для возврата на OverviewCategoryPage
      navigateToPage(
        context,
        route: OverviewCategoryRoute(categoryKey: categoryKey, model: model),
        replace:
            true, // или clearStack: true, в зависимости от вашей навигационной логики
      );
      return true;
    }
    return false;
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

  const QuestionCard({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.isAnswered,
    required this.userAnswer,
    required this.isCorrect,
    required this.allQuestions,
    required this.userAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final correctCount =
        allQuestions
            .where((q) => userAnswers[q.question] == q.correctOption)
            .length;
    final incorrectCount = userAnswers.length - correctCount;

    return Card(
      color: AppColors.lightBackground,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(12.r),
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
                  style: AppTextStyles.merriweatherBold14,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.only(left: 8.w, bottom: 2.h, top: 2.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColorDark,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '$questionNumber ${LocaleKeys.outOf.tr()} ${allQuestions.length} /',
                        style: AppTextStyles.robotoMono16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$incorrectCount',
                        style: AppTextStyles.robotoMono16.copyWith(
                          color: Colors.red,
                        ),
                      ),
                      const Text(' / '),
                      Text(
                        '$correctCount',
                        style: AppTextStyles.robotoMono16.copyWith(
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const ResetButton(),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(question.question, style: AppTextStyles.regular16),
            SizedBox(height: 16.h),
            ...QuestionOptions.buildOptions(
              context,
              question,
              isAnswered,
              userAnswer,
              isCorrect,
            ),
            if (isAnswered) ...[
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .center, // Добавлено для выравнивания по центру
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          right: 8.w,
                        ), // Увеличено пространство между иконкой и текстом
                        child: SvgPicture.asset(
                          AppLogos.explanation,
                          height: 24.h, // Стандартный размер для иконок
                          width: 24.h, // Добавлено для сохранения пропорций
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).iconTheme.color!,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Text(
                        LocaleKeys.explanation.tr(),
                        style: AppTextStyles.manropeBold14.copyWith(
                          color:
                              Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.color, // Использование тематического цвета
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ), // Увеличено пространство между заголовком и описанием
                  Padding(
                    padding: EdgeInsets.only(
                      left: 32.w,
                    ), // Отступ для выравнивания с иконкой
                    child: Text(
                      question.description,
                      style: AppTextStyles.merriweatherBold14.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        height: 1.4, // Улучшенный межстрочный интервал
                      ),
                    ),
                  ),
                ],
              ),
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

  const QuestionOptions({
    super.key,
    required this.question,
    required this.isAnswered,
    required this.userAnswer,
    required this.isCorrect,
  });

  static List<Widget> buildOptions(
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
                  child: Text(optionText, style: TextStyle(color: textColor)),
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
            context.read<CDLTestsBloc>().add(const ResetQuizEvent());
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

class ResetButton extends StatelessWidget {
  const ResetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showResetConfirmationDialog(context);
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),

        elevation: 3,
        backgroundColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.3),
        shadowColor: Colors.black.withValues(alpha: 0.2),
      ),
      child: SvgPicture.asset(
        AppLogos.reset,
        height: 20.h,
        colorFilter: ColorFilter.mode(
          Theme.of(context).iconTheme.color!,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  void _showResetConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(LocaleKeys.resetQuiz.tr()),
            content: Text(LocaleKeys.startTheQuizOverText.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(LocaleKeys.cancel.tr()),
              ),
              TextButton(
                onPressed: () {
                  context.read<CDLTestsBloc>().add(const ResetQuizEvent());
                  Navigator.of(context).pop();
                },
                child: Text(LocaleKeys.reset.tr()),
              ),
            ],
          ),
    );
  }
}
