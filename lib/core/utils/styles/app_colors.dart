import 'package:flutter/material.dart';

abstract class AppColors {
  // static Color primaryColor = Colors.black; //0xff4e4edd
  static Color primaryColor = const Color(0x99FFDE36); //0xff4e4edd
  static Color secondaryColor = const Color(0xff5c6221);
  static Color lowPriority = const Color(0x991E8DA0);
  static Color darkColor = const Color(0xff2f3600);
  static Color scaffoldColor = const Color(0xff28291a);
  static Color orangeColor = const Color(0xff947501);
  static Color appBarColor = const Color(0xffafd499);
  static Color primaryLight = const Color(0xff31313F);
  static Color transparent = const Color(0x00ffffff);

  static Color green = const Color(0xf461df25);

  static Color blue = const Color(0xf4253edf);
  static Color red = const Color(0xf4df2535);
  static Color white = const Color(0xffffffff);
  static Color grey = const Color(0xffF5F5F5);
  static Color greyDark = const Color(0xff898989);

  static Color black = const Color(0xff000000);
}

extension HexOnColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString"; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
