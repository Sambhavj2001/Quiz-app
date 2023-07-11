import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:quiz_app/controllers/auth_controller.dart';
import 'package:quiz_app/controllers/question_paper/question_controller_extension.dart';
import 'package:quiz_app/controllers/question_paper/question_paper_controller.dart';
import 'package:quiz_app/firebase_ref/loading_status.dart';
import 'package:quiz_app/firebase_ref/refrences.dart';
import 'package:quiz_app/models/question_paper_model.dart';
import 'package:quiz_app/screens/home/home_screen.dart';
import 'package:quiz_app/screens/questions/result_screen.dart';

class QuestionsController extends GetxController {
  late QuestionPaperModel questionPaperModel;
  final allQuestions = <Questions>[];
  final loadingStatus = LoadingStatus.loading.obs;
  final questionIndex = 0.obs;
  bool get isFirstQuestion => questionIndex.value > 0;
  bool get isLastQuestion => questionIndex >= allQuestions.length - 1;
  Rxn<Questions> currentQuestion = Rxn<Questions>();

  Timer? _timer;
  int remainSeconds = 1;
  final time = '00:00'.obs;

  @override
  void onReady() {
    final _questionPaper = Get.arguments as QuestionPaperModel;
    loadData(_questionPaper);
    super.onReady();
  }

  Future<void> loadData(QuestionPaperModel questionPaper) async {
    questionPaperModel = questionPaper;
    loadingStatus.value = LoadingStatus.loading;
    try {
      final QuerySnapshot<Map<String, dynamic>> questionQuery =
          await questionPaperRF
              .doc(questionPaper.id)
              .collection("questions")
              .get();
      final questions = questionQuery.docs
          .map((snapshot) => Questions.fromSnapshot(snapshot))
          .toList();
      questionPaper.questions = questions;
      for (Questions _questions in questionPaper.questions!) {
        final QuerySnapshot<Map<String, dynamic>> answerQuery =
            await questionPaperRF
                .doc(questionPaper.id)
                .collection("questions")
                .doc(_questions.id)
                .collection("answers")
                .get();
        final answers = answerQuery.docs
            .map((snapShot) => Answers.fromSnapshot(snapShot))
            .toList();
        _questions.answers = answers;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    if (questionPaper.questions != null &&
        questionPaper.questions!.isNotEmpty) {
      allQuestions.assignAll(questionPaper.questions!);
      currentQuestion.value = questionPaper.questions![0];
      _startTimer(questionPaper.timeSeconds);
      loadingStatus.value = LoadingStatus.completed;
    } else {
      loadingStatus.value = LoadingStatus.error;
    }
  }

  void selectedAnswer(String? answer) {
    currentQuestion.value!.selectedAnswer = answer;
    update(['answer_list', 'answer_review_list']);
  }

  String get completedTest {
    final answered = allQuestions
        .where((element) => element.selectedAnswer != null)
        .toList()
        .length;
    return '$answered out of ${allQuestions.length} answered';
  }

  void jumpToQuestion(int index, {bool isGoBack = true}) {
    questionIndex.value = index;
    currentQuestion.value = allQuestions[index];
    if (isGoBack) {
      Get.back();
    }
  }

  void nextQuestion() {
    if (questionIndex.value <= allQuestions.length - 1) {
      questionIndex.value++;
      currentQuestion.value = allQuestions[questionIndex.value];
      return;
    }
  }

  void prevQuestion() {
    if (questionIndex.value > 0) {
      questionIndex.value--;
      currentQuestion.value = allQuestions[questionIndex.value];
      return;
    }
  }

  _startTimer(int seconds) {
    const duration = Duration(seconds: 1);
    remainSeconds = seconds;
    _timer = Timer.periodic(duration, (Timer timer) {
      if (remainSeconds == 0) {
        timer.cancel();
      } else {
        int minutes = remainSeconds ~/ 60;
        int seconds = remainSeconds % 60;
        time.value = minutes.toString().padLeft(2, "0") +
            ":" +
            seconds.toString().padLeft(2, "0");
        remainSeconds--;
      }
    });
  }

  void complete() {
    _timer!.cancel();
    Get.offAndToNamed(ResultScreen.routeName);
  }

  void tryAgain() {
    Get.find<QuestionPaperController>().navigateToQuestions(
      paper: questionPaperModel,
      tryAgain: true,
    );
  }

  void navigateToHome() {
    _timer!.cancel();
    Get.offNamedUntil(HomeScreen.routeName, (route) => false);
  }

  Future<void> saveTestResults() async {
    var batch = fireStore.batch();

    User? _user = Get.find<AuthController>().getUser();

    if (_user == null) return;

    batch.set(
        userRf
            .doc(_user.email)
            .collection('my_recent_tests')
            .doc(questionPaperModel.id),
        {
          "points": points,
          "correct_answer": '$correctQuestionCount/${allQuestions.length}',
          "question_id": questionPaperModel.id,
          "time": questionPaperModel.timeSeconds - remainSeconds
        });

    batch.commit();

    navigateToHome();
  }
}
