import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/configs/themes/app_colors.dart';
import 'package:quiz_app/configs/themes/ui_parameters.dart';
import 'package:quiz_app/controllers/question_paper/questions_controller.dart';
import 'package:quiz_app/firebase_ref/loading_status.dart';
import 'package:quiz_app/widgets/background_Decoration.dart';
import 'package:quiz_app/widgets/content_area.dart';
import 'package:quiz_app/widgets/countdown_timer.dart';
import 'package:quiz_app/widgets/main_button.dart';
import 'package:quiz_app/widgets/question_place_holder.dart';

import '../../configs/themes/custom_text_styles.dart';
import '../../widgets/custom_app_bar.dart';
import 'answer_card.dart';
import 'test_overview_screen.dart';

class QuestionsScreen extends GetView<QuestionsController> {
  const QuestionsScreen({Key? key}) : super(key: key);

  static const String routeName = "/questions";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        leading: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: ShapeDecoration(
            shape: StadiumBorder(
              side: BorderSide(color: onSurfaceTextColor, width: 2),
            ),
          ),
          child: Obx(
            () => CountDownTimer(
              time: controller.time.value,
              color: onSurfaceTextColor,
            ),
          ),
        ),
        showActionIcon: true,
        titleWidget: Obx(
          () => Text(
            'Q ${(controller.questionIndex.value + 1).toString().padLeft(2, '0')}',
            style: appBarText,
          ),
        ),
      ),
      body: BackgroundDecoration(
        child: Obx(
          () => Column(
            children: [
              if (controller.loadingStatus.value == LoadingStatus.loading)
                const Expanded(
                    child: ContentArea(child: QuestionScreenHolder())),
              if (controller.loadingStatus.value == LoadingStatus.completed)
                Expanded(
                  child: ContentArea(
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          padding: const EdgeInsets.only(top: 25),
                          child: Column(
                            children: [
                              Text(
                                controller.currentQuestion.value!.question,
                                style: questionsText,
                              ),
                              GetBuilder<QuestionsController>(
                                id: 'answer_list',
                                builder: (context) {
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.only(top: 25),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final answer = controller.currentQuestion
                                          .value!.answers[index];
                                      return AnswerCard(
                                        answer:
                                            '${answer.identifier}. ${answer.answer}',
                                        onTap: () {
                                          controller.selectedAnswer(
                                              answer.identifier);
                                        },
                                        isSelected: answer.identifier ==
                                            controller.currentQuestion.value!
                                                .selectedAnswer,
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const SizedBox(height: 10),
                                    itemCount: controller
                                        .currentQuestion.value!.answers.length,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: UIParameters.mobileScreenPadding,
                          child: Row(
                            children: [
                              Visibility(
                                visible: controller.isFirstQuestion,
                                child: SizedBox(
                                  width: 55,
                                  height: 55,
                                  child: MainButton(
                                    onTap: () {
                                      controller.prevQuestion();
                                    },
                                    child: Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Get.isDarkMode
                                          ? onSurfaceTextColor
                                          : Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Visibility(
                                  visible: controller.loadingStatus.value ==
                                      LoadingStatus.completed,
                                  child: MainButton(
                                    onTap: () {
                                      controller.isLastQuestion
                                          ? Get.toNamed(
                                              TestOverViewScreen.routeName)
                                          : controller.nextQuestion();
                                    },
                                    title: controller.isLastQuestion
                                        ? 'Submit'
                                        : 'Next',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
