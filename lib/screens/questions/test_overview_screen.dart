import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/configs/themes/custom_text_styles.dart';
import 'package:quiz_app/configs/themes/ui_parameters.dart';
import 'package:quiz_app/controllers/question_paper/questions_controller.dart';
import 'package:quiz_app/screens/questions/answer_card.dart';
import 'package:quiz_app/widgets/background_Decoration.dart';
import 'package:quiz_app/widgets/content_area.dart';
import 'package:quiz_app/widgets/countdown_timer.dart';
import 'package:quiz_app/widgets/custom_app_bar.dart';
import 'package:quiz_app/widgets/question_number_card.dart';

import '../../configs/themes/app_colors.dart';
import '../../widgets/main_button.dart';

class TestOverViewScreen extends GetView<QuestionsController> {
  const TestOverViewScreen({Key? key}) : super(key: key);

  static const String routeName = '/testOverview';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        leading: SizedBox(
          height: 40,
        ),
        title: controller.completedTest,
      ),
      body: BackgroundDecoration(
        child: Column(
          children: [
            Expanded(
              child: ContentArea(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CountDownTimer(
                        time: '',
                        color: UIParameters.isDarkMode()
                            ? Theme.of(Get.context!).textTheme.bodyText1!.color
                            : Theme.of(Get.context!).primaryColor,
                      ),
                      Obx(
                        () => Text(
                          '${controller.time} Remaining',
                          style: countDownTimerText(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      itemCount: controller.allQuestions.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Get.width ~/ 75,
                        childAspectRatio: 1,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (_, index) {
                        AnswerStatus? _answerStatus;
                        if (controller.allQuestions[index].selectedAnswer !=
                            null) {
                          _answerStatus = AnswerStatus.answered;
                        }
                        return QuestionNumberCard(
                          index: index + 1,
                          status: _answerStatus,
                          onTap: () => controller.jumpToQuestion(index),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: UIParameters.mobileScreenPadding,
                    child: MainButton(
                      onTap: () {
                        controller.complete();
                      },
                      title: 'Submit',
                    ),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
