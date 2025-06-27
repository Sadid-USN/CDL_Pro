import 'package:auto_route/auto_route.dart';
import 'package:cdl_pro/core/core.dart';
import 'package:cdl_pro/core/utils/utils.dart';
import 'package:cdl_pro/domain/models/models.dart';
import 'package:cdl_pro/generated/locale_keys.g.dart';
import 'package:cdl_pro/presentation/blocs/cdl_tests_bloc/cdl_tests.dart';
import 'package:cdl_pro/presentation/pages/home/quiz/widgets/widgets.dart';
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
  final String categoryKey;
  final TestsDataModel model;

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
                  // await context.read<CDLTestsBloc>().saveProgress();
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
    final cardNumber = ((startIndex - 1) ~/ questions.length) + 1;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          Text(chapterTitle, style: AppTextStyles.merriweatherBold14),
          Text(
            ' #$cardNumber',
            style: AppTextStyles.robotoMonoBold14.copyWith(),
          ),
        ],
      ),
    );
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

  // void _goToProfilePage(BuildContext context) {
  //   navigateToPage(
  //     context,
  //     route: const ProfileRoute(), // ← свой auto_route к профилю
  //     clearStack: true,
  //   );
  // }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    final uid = context.read<CDLTestsBloc>().uid;
    final bool isLoggedIn = uid != null;

    // Тексты для диалога в зависимости от статуса авторизации
    final exitText =
        isLoggedIn ? LocaleKeys.exit.tr() : LocaleKeys.dontLoseProgress.tr();
    final confirmText =
        isLoggedIn ? LocaleKeys.yes.tr() : LocaleKeys.login.tr();
    final cancelText =
        isLoggedIn
            ? LocaleKeys.no.tr()
            : LocaleKeys.exit.tr(); // Заменяем "cancel" на "exit"

    bool userChoice = false;

    await showConfirmationDialog(
      context: context,
      title: exitText,
      description: isLoggedIn ? LocaleKeys.areYouSureYouWantToExit.tr() : '',
      cancelText: cancelText,
      confirmText: confirmText,
      onConfirm: () => userChoice = true,
    );

    if (!context.mounted) return false;

    if (userChoice) {
      // Пользователь выбрал "Login" или "Yes"
      if (isLoggedIn) {
      
        navigateToPage(
          context,
          route: OverviewCategoryRoute(categoryKey: categoryKey, model: model),
          replace: true,
        );
      } else {
        navigateToPage(context, route: const ProfileRoute(), clearStack: true);
      }
      return true;
    } else {
      // Пользователь выбрал "Exit" или "No"
      if (!isLoggedIn) {
        // Для незалогиненного пользователя "Exit" ведёт к спискам
        navigateToPage(
          context,
          route: OverviewCategoryRoute(categoryKey: categoryKey, model: model),
          replace: true,
        );
        return true;
      }
      return false; // Для залогиненного "No" оставляет на странице
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
        NextBackButtons(
          isFirstQuestion: state.currentPage == 0,
          isLastQuestion: state.currentPage == state.allQuestions.length - 1,
          isAnswered: isAnswered,
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

    return BlocBuilder<CDLTestsBloc, AbstractCDLTestsState>(
      builder: (context, state) {
        return StreamBuilder<Duration>(
          stream: context.read<CDLTestsBloc>().timerStream,
          initialData: Duration.zero,
          builder: (context, snapshot) {
            final elapsedTime = snapshot.data ?? Duration.zero;
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
                            namedArgs: {
                              "questionNumber": questionNumber.toString(),
                            },
                          ),
                          style: AppTextStyles.merriweatherBold14,
                        ),

                        Text(
                          DateFormatters.formatDuration(elapsedTime),
                          style: AppTextStyles.robotoMono14,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    ProgressBar(
                      questionNumber: questionNumber,
                      allQuestions: allQuestions.length,
                      incorrectCount: incorrectCount,
                      correctCount: correctCount,
                    ),
                    AuthReminderBanner(),

                    // if (context.read<CDLTestsBloc>().uid == null)
                    //   Padding(
                    //     padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                    //     child: Text(
                    //       LocaleKeys.logInToSaveProgress.tr(),
                    //       style: AppTextStyles.merriweather10.copyWith(
                    //         color: AppColors.errorColor,
                    //       ),
                    //     ),
                    //   ),
                    SizedBox(height: 8.h),
                    Text(
                      question.question,
                      style: AppTextStyles.merriweather16.copyWith(
                        color: AppColors.softBlack,
                      ),
                    ),
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: SvgPicture.asset(
                                  AppLogos.explanation,
                                  height: 22.h,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.goldenSoft,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              Text(
                                LocaleKeys.explanation.tr(),
                                style: AppTextStyles.merriweatherBold14
                                    .copyWith(
                                      color:
                                          Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.color,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Padding(
                            padding: EdgeInsets.only(left: 32.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  question.description,
                                  style: AppTextStyles.merriweatherBold14,
                                ),
                                SizedBox(height: 12.h),
                                if (question.images?.isNotEmpty ?? false)
                                  GalleryButton(images: question.images),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
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

      Color? iconColor;

      if (isAnswered) {
        if (isCorrectOption) {
          backgroundColor = AppColors.greenSoft;

          iconColor = AppColors.simpleGreen;
        } else if (isSelected) {
          backgroundColor = AppColors.errorColor.withValues(alpha: 0.4);

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
        child: Container(
          margin: EdgeInsets.only(bottom: 8.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '$optionKey •',
                style: AppTextStyles.merriweatherBold16.copyWith(
                  color: AppColors.darkBackground,
                ),
              ),

              SizedBox(width: 7.w),
              Expanded(
                child: Text(
                  optionText,
                  style: AppTextStyles.merriweather12.copyWith(
                    color: AppColors.darkBackground,
                  ),
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
