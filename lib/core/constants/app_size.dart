import 'package:authentication_firebase_test/core/constants/constants.dart';
import 'package:flutter/material.dart';

class AppSize {
  static const double kAppDefaultPadding = 8.0;
  static const double kAppDefaultRadius = 8.0;
  static const double kAppCircleRadius = 100.0;
  static  final kAppBoxShadow = BoxShadow(
    color: AppColors.kPrimaryLight,
    spreadRadius: 3,
    blurRadius: 5,
    offset: const Offset(0, 0),
  );
  static const kAppBorderLeftRadius = BorderRadius.only(
    bottomLeft: Radius.circular(AppSize.kAppDefaultRadius),
    topLeft: Radius.circular(AppSize.kAppDefaultRadius),
  );
  static const kAppBorderRightRadius = BorderRadius.only(
    bottomRight: Radius.circular(AppSize.kAppDefaultRadius),
    topRight: Radius.circular(AppSize.kAppDefaultRadius),
  );
}
