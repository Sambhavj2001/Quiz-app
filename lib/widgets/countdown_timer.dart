import 'package:flutter/material.dart';
import 'package:quiz_app/configs/themes/custom_text_styles.dart';

class CountDownTimer extends StatelessWidget {
  final Color? color;
  final String time;
  const CountDownTimer({Key? key, this.color, required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.timer,
          color: color ?? Theme.of(context).primaryColor,
        ),
        SizedBox(width: 5),
        Text(
          time,
          style: countDownTimerText().copyWith(color: color),
        ),
      ],
    );
  }
}
