import 'package:flutter/material.dart';
import 'package:quiz_app/configs/themes/app_colors.dart';
import 'package:quiz_app/widgets/app_circle_button.dart';
import 'package:get/get.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: mainGradient()),
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                size: 65,
              ),
              SizedBox(height: 40),
              Text(
                'This is a study app. You can use it for study . . .',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: onSurfaceTextColor,
                ),
              ),
              SizedBox(height: 40),
              AppCircleButton(
                onTap: () => Get.offAndToNamed("/home"),
                child: Icon(
                  Icons.arrow_forward,
                  size: 35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
