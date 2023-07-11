import 'package:get/get.dart';
import 'package:quiz_app/controllers/question_paper/question_paper_controller.dart';
import 'package:quiz_app/controllers/question_paper/questions_controller.dart';
import 'package:quiz_app/controllers/zoom_drawer_controller.dart';
import 'package:quiz_app/screens/home/home_screen.dart';
import 'package:quiz_app/screens/home/login_screen.dart';
import 'package:quiz_app/screens/introduction_screen.dart';
import 'package:quiz_app/screens/questions/check_answer_screen.dart';
import 'package:quiz_app/screens/questions/questions_screen.dart';
import 'package:quiz_app/screens/questions/test_overview_screen.dart';
import 'package:quiz_app/screens/splash_screen.dart';

import '../screens/questions/result_screen.dart';

class AppRoutes {
  static List<GetPage> routes() => [
        GetPage(name: "/", page: () => SplashScreen()),
        GetPage(name: "/introduction", page: () => IntroductionScreen()),
        GetPage(
            name: "/home",
            page: () => HomeScreen(),
            binding: BindingsBuilder(() {
              Get.put(QuestionPaperController());
              Get.put(MyZoomDrawerController());
            })),
        GetPage(name: LoginScreen.routeName, page: () => LoginScreen()),
        GetPage(
          name: QuestionsScreen.routeName,
          page: () => QuestionsScreen(),
          binding: BindingsBuilder(() {
            Get.put<QuestionsController>(QuestionsController());
          }),
        ),
        GetPage(
            name: TestOverViewScreen.routeName,
            page: () => TestOverViewScreen()),
        GetPage(name: ResultScreen.routeName, page: () => ResultScreen()),
        GetPage(
            name: CheckAnswerScreen.routeName, page: () => CheckAnswerScreen()),
      ];
}
