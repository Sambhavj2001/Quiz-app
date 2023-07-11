import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/configs/themes/custom_text_styles.dart';
import 'package:quiz_app/controllers/question_paper/questions_controller.dart';
import 'package:quiz_app/widgets/content_area.dart';

import '../../widgets/background_Decoration.dart';
import '../../widgets/custom_app_bar.dart';
import 'answer_card.dart';

class CheckAnswerScreen extends GetView<QuestionsController> {
  const CheckAnswerScreen({Key? key}) : super(key: key);

  static const String routeName = '/checkAnswer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        titleWidget: Obx(
          () => Text(
            'Q ${(controller.questionIndex.value + 1).toString().padLeft(2, '0')}',
            style: appBarText,
          ),
        ),
        showActionIcon: true,
        onMenuActionTap: () {},
      ),
      body: BackgroundDecoration(
        child: Obx(
          () => Column(
            children: [
              Expanded(
                child: ContentArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Text(
                          controller.currentQuestion.value!.question,
                          style: questionsText,
                        ),
                        GetBuilder<QuestionsController>(
                          id: 'answer_review_list',
                          builder: (context) {
                            return ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 25),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                final answer = controller
                                    .currentQuestion.value!.answers[index];
                                final selectedAnswer = controller
                                    .currentQuestion.value!.selectedAnswer;
                                final correctAnswer = controller
                                    .currentQuestion.value!.correctAnswer;
                                final String answerText =
                                    '${answer.identifier}.${answer.answer}';
                                if (correctAnswer == selectedAnswer &&
                                    answer.identifier == selectedAnswer) {
                                  return CorrectAnswer(answer: answerText);
                                } else if (selectedAnswer == null) {
                                  return NotAnswered(answer: answerText);
                                } else if (correctAnswer != selectedAnswer &&
                                    answer.identifier == selectedAnswer) {
                                  return WrongAnswer(answer: answerText);
                                } else if (correctAnswer == answer.identifier) {
                                  return CorrectAnswer(answer: answerText);
                                }
                                return AnswerCard(
                                  answer: answerText,
                                  onTap: () {},
                                  isSelected: false,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
