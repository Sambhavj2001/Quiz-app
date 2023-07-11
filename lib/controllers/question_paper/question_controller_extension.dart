import 'package:quiz_app/controllers/question_paper/questions_controller.dart';

extension QuestionControllerExtension on QuestionsController {
  int get correctQuestionCount => allQuestions
      .where((element) => element.selectedAnswer == element.correctAnswer)
      .toList()
      .length;

  String get correctAnsweredQuestions {
    return '$correctQuestionCount out of ${allQuestions.length}';
  }

  String get points {
    var points = (correctQuestionCount / allQuestions.length) * 100 +
        (questionPaperModel.timeSeconds - remainSeconds) /
            questionPaperModel.timeSeconds *
            100;
    return points.toStringAsFixed(2);
  }
}
