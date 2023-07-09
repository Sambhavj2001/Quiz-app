import 'package:flutter/material.dart';
import 'package:quiz_app/configs/themes/sub_themes.dart';

const Color primaryLightColor1 = Color(0xFF3ac3cb);
const Color primaryLightColor2 = Color(0xFFf85187);
const Color mainTextColorLight = Color.fromARGB(255, 40, 40, 40);
const Color cardColor = Color.fromARGB(255, 254, 254, 255);

class LightTheme with SubThemeData {
  buildLightTheme() {
    final ThemeData systemLightTheme = ThemeData.light();
    return systemLightTheme.copyWith(
      primaryColor: primaryLightColor2,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      iconTheme: getIconTheme(),
      cardColor: cardColor,
      textTheme: getTextThemes().apply(
          bodyColor: mainTextColorLight, displayColor: mainTextColorLight),
    );
  }
}
