import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:quiz_app/configs/themes/custom_text_styles.dart';
import 'package:quiz_app/configs/themes/ui_parameters.dart';
import 'package:quiz_app/controllers/question_paper/question_paper_controller.dart';
import 'package:quiz_app/controllers/zoom_drawer_controller.dart';
import 'package:quiz_app/screens/home/menu_screen.dart';
import 'package:quiz_app/screens/home/question_card.dart';
import 'package:quiz_app/widgets/app_circle_button.dart';
import 'package:quiz_app/widgets/content_area.dart';

import '../../configs/themes/app_colors.dart';

class HomeScreen extends GetView<MyZoomDrawerController> {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    QuestionPaperController _questionPaperController = Get.find();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: mainGradient()),
        child: GetBuilder<MyZoomDrawerController>(
          builder: (_) {
            return ZoomDrawer(
              borderRadius: 50.0,
              controller: _.zoomDrawerController,
              showShadow: false,
              moveMenuScreen: false,
              angle: 0.0,
              style: DrawerStyle.defaultStyle,
              slideWidth: MediaQuery.of(context).size.width * 0.85,
              menuScreen: MyMenuScreen(),
              mainScreen: Container(
                decoration: BoxDecoration(gradient: mainGradient()),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(mobileScreenPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppCircleButton(
                              child: Icon(
                                Icons.menu_outlined,
                                size: 30,
                              ),
                              onTap: controller.toogleDrawer,
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                children: [
                                  Icon(Icons.front_hand_outlined),
                                  SizedBox(width: 4),
                                  Text(
                                    'Hello Friends',
                                    style: detailText.copyWith(
                                        color: onSurfaceTextColor),
                                  )
                                ],
                              ),
                            ),
                            Text(
                              'Which Quiz do you want to do today?',
                              style: headerText,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ContentArea(
                            addPadding: false,
                            child: Obx(
                              () => ListView.separated(
                                padding: UIParameters.mobileScreenPadding,
                                itemBuilder: (BuildContext context, int index) {
                                  return QuestionCard(
                                      model: _questionPaperController
                                          .allPapers[index]);
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(height: 20);
                                },
                                itemCount:
                                    _questionPaperController.allPapers.length,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
