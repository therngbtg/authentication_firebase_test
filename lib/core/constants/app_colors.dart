import 'package:flutter/material.dart';

class AppColors {

  static Color kLightColor = const Color(0xFFFFFFFF);
  // F9F9F9
  static Color kPrimaryLight = const Color(0xFFf2f2f2);

  // text color
static Color kTextColor = const Color(0xFF6d6d6d);
  // #BCBCBC
  static Color kTextGreyColor = const Color(0xFFbcbcbc);

//   #008AA1
  static Color kBlue = const Color(0xFF008AA1);

  // #00B5C4
  static Color kLightBlue = const Color(0xFF00B5C4);

  // #8C386F
  static Color kPurple = const Color(0xFF8C386F);

  // #A03F7B
  static Color kPink = const Color(0xFFA03F7B);

  // #ED1C32
  static Color kRed = const Color(0xFFED1C32);

  // #FA703B
  static Color kOrange = const Color(0xFFFA703B);

  // #005731
  static Color kDarkGreen = const Color(0xFF005731);

  // #6CB649
  static Color kLightGreen = const Color(0xFF6CB649);

  // dark blue
  static Color kDarkBlue = const Color(0xFF2d2d60);

  // Blue #168cef
  static Color kBlueColor = const Color(0xFF168cef);


  // kGreen button
  // #43AA2D
  static Color kGreenButton = const Color(0xFF43AA2D);


  static const MaterialColor kPrimaryColor = MaterialColor(
    _kPrimaryColor,
    <int, Color>{
      50: Color.fromRGBO(159,161 ,163 , 0.1),
      100: Color.fromRGBO(159,161 ,163 , 0.2),
      200: Color.fromRGBO(159,161 ,163 , 0.3),
      300: Color.fromRGBO(159,161 ,163 , 0.4),
      400: Color.fromRGBO(159,161 ,163 , 0.5),
      500: Color(_kPrimaryColor),
      600: Color.fromRGBO(159,161 ,163 , 0.7),
      700: Color.fromRGBO(159,161 ,163 , 0.8),
      800: Color.fromRGBO(159,161 ,163 , 0.9),
      900: Color.fromRGBO(159,161 ,163 , 1),
    },
  );
  static const int _kPrimaryColor = 0xFF9FA1A3;
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
