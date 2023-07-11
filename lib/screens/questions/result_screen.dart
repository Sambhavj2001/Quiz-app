import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quiz_app/configs/themes/custom_text_styles.dart';
import 'package:quiz_app/controllers/question_paper/question_controller_extension.dart';
import 'package:quiz_app/screens/questions/check_answer_screen.dart';

import '../../configs/themes/ui_parameters.dart';
import '../../controllers/question_paper/questions_controller.dart';
import '../../widgets/background_Decoration.dart';
import '../../widgets/content_area.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/main_button.dart';
import '../../widgets/question_number_card.dart';
import 'answer_card.dart';

class ResultScreen extends GetView<QuestionsController> {
  const ResultScreen({Key? key}) : super(key: key);

  static const String routeName = '/result';

  @override
  Widget build(BuildContext context) {
    Color _textColor =
        Get.isDarkMode ? Colors.white : Theme.of(context).primaryColor;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        leading: SizedBox(height: 80),
        title: controller.correctAnsweredQuestions,
      ),
      body: BackgroundDecoration(
        child: Column(
          children: [
            Expanded(
              child: ContentArea(
                  child: Column(
                children: [
                  SvgPicture.asset('assets/images/bulb.svg'),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 5),
                    child: Text(
                      'Congratulations',
                      style: headerText.copyWith(color: _textColor),
                    ),
                  ),
                  Text(
                    'You got ${controller.points} Points.',
                    style: TextStyle(color: _textColor),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Tap below question numbers to view correct answers',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: GridView.builder(
                      itemCount: controller.allQuestions.length,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Get.width ~/ 75,
                        childAspectRatio: 1,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (_, index) {
                        final _question = controller.allQuestions[index];
                        AnswerStatus _status = AnswerStatus.notAnswered;
                        final _selectedAnswer = _question.selectedAnswer;
                        final _correctAnswer = _question.correctAnswer;
                        if (_selectedAnswer == _correctAnswer) {
                          _status = AnswerStatus.correct;
                        } else if (_question.selectedAnswer == null) {
                          _status = AnswerStatus.wrong;
                        } else {
                          _status = AnswerStatus.wrong;
                        }
                        return QuestionNumberCard(
                          index: index + 1,
                          status: _status,
                          onTap: () {
                            controller.jumpToQuestion(index, isGoBack: false);
                            Get.toNamed(CheckAnswerScreen.routeName);
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: UIParameters.mobileScreenPadding,
                    child: Row(
                      children: [
                        Expanded(
                          child: MainButton(
                            onTap: () {
                              controller.tryAgain();
                            },
                            color: Colors.blueGrey,
                            title: 'Try Again',
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: MainButton(
                            onTap: () {
                              controller.saveTestResults();
                            },
                            title: 'Go home',
                          ),
                        ),
                      ],
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
