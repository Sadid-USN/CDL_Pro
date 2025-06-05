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
class QuizPage extends StatefulWidget {
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
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage>
    with AutomaticKeepAliveClientMixin {
  late String _quizId;
  bool _initialLoadComplete = false;

  @override
  void initState() {
    super.initState();
    _quizId =
        widget.questions
            .map((q) => q.question.hashCode.toString())
            .join('_')
            .hashCode
            .toString();

    // Инициируем загрузку квиза при инициализации
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<CDLTestsBloc>();
      bloc.add(LoadQuizEvent(widget.questions, initialLanguage: 'en'));
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bloc = context.read<CDLTestsBloc>();

    return BlocConsumer<CDLTestsBloc, AbstractCDLTestsState>(
      listener: (context, state) {
        if (state is QuizLoadedState) {
          _initialLoadComplete = true;
          bloc.add(SaveQuizProgressEvent());
        }
      },
      builder: (context, state) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) async {
                if (!didPop) {
                  await bloc.saveProgress();
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
    final currentPage = state is QuizLoadedState ? state.currentPage : 0;
    return Text(
      '${widget.chapterTitle} (${widget.startIndex + currentPage + 1} / ${widget.questions.length})',
      style: AppTextStyles.manrope10,
    );
  }

  Widget _buildBody(AbstractCDLTestsState state) {
    if (state is QuizLoadedState) {
      return OrientationBuilder(
        builder: (context, orientation) {
          return SingleQuestionView(
            key: ValueKey(state.currentPage),
            state: state,
            chapterTitle: widget.chapterTitle,
            questions: widget.questions,
            startIndex: widget.startIndex,
          );
        },
      );
    } else if (state is QuizProgressLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is PremiumInitial || state is PremiumLoading) {
      // Показываем загрузку, пока проверяется премиум-статус
      return const Center(child: CircularProgressIndicator());
    }

    // Fallback - если состояние неизвестно
    return const Center(child: CircularProgressIndicator());
  }

  Future<void> _showExitConfirmation(BuildContext context) async {
    final bloc = context.read<CDLTestsBloc>();
    final shouldExit =
        await showDialog<bool>(
          context: context,
          builder:
              (dialogContext) => AlertDialog(
                title: Text(LocaleKeys.confirm.tr()),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text(LocaleKeys.areYouSureYouWantToExit.tr())],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: Text(LocaleKeys.no.tr()),
                  ),
                  TextButton(
                    onPressed: () async {
                      await bloc.saveProgress();
                      if (dialogContext.mounted) {
                        Navigator.of(dialogContext).pop(true);
                      }
                    },
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
                Row(
                  children: [
                    const ResetButton(),
                    const SizedBox(width: 8),

                    TranslationButton(
                      initialLanguage: selectedLanguage,
                      onLanguageChanged: (lang) {
                        bloc.add(ChangeLanguageEvent(lang));
                      },
                    ),
                  ],
                ),
              ],
            ),
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
                  selectedLanguage != 'en'
                      ? bloc.translateText(question.question, selectedLanguage)
                      : Future.value(question.question),
              builder: (context, snapshot) {
                return KeyedSubtree(
                  key: ValueKey(
                    'question_${question.question}_$selectedLanguage',
                  ),
                  child: Text(
                    snapshot.data ?? question.question,
                    style: AppTextStyles.regular16,
                  ),
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
              FutureBuilder<String>(
                future:
                    selectedLanguage != 'en'
                        ? bloc.translateText(
                          question.description,
                          selectedLanguage,
                        )
                        : Future.value(question.description),
                builder: (context, snapshot) {
                  return KeyedSubtree(
                    key: ValueKey(
                      'description_${question.description}_$selectedLanguage',
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(LocaleKeys.explanation.tr()),
                        const SizedBox(height: 4),
                        Text(
                          snapshot.data ?? question.description,
                          style: AppTextStyles.manrope14,
                        ),
                      ],
                    ),
                  );
                },
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
    String selectedLanguage,
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
                        selectedLanguage != 'en'
                            ? bloc.translateText(optionText, selectedLanguage)
                            : Future.value(optionText),
                    builder: (context, snapshot) {
                      return KeyedSubtree(
                        key: ValueKey('option_${optionText}_$selectedLanguage'),
                        child: Text(
                          snapshot.data ?? optionText,
                          style: TextStyle(color: textColor),
                        ),
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
            // При завершении теста сбрасываем данные
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
    return IconButton(
      icon: const Icon(Icons.restart_alt),
      tooltip: LocaleKeys.resetQuiz.tr(),
      onPressed: () {
        _showResetConfirmationDialog(context);
      },
    );
  }

  void _showResetConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              LocaleKeys.resetQuiz.tr(),
              style: TextStyle(color: AppColors.darkBackground),
            ),
            content: Text(
              LocaleKeys.startTheQuizOverText.tr(),
              style: TextStyle(color: AppColors.darkBackground),
            ),
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
