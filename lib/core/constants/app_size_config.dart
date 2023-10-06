import 'package:flutter/material.dart';

import 'constants.dart';

class AppSizeConfig {
  static const appEdgeInsetsGeometryMobile =
      EdgeInsets.all(AppSize.kAppDefaultPadding * 2);
  static const appEdgeInsetsGeometryIPAD =
      EdgeInsets.all(AppSize.kAppDefaultPadding * 8);

  static double maxWidth = 0;
  static double maxHeight = 0;
  static double _screenWidth = 0;
  static double _screenHeight = 0;
  static double _blockWidth = 0;
  static double _blockHeight = 0;

  static double textMultiplier = 0;
  static double imageSizeMultiplier = 0;
  static double heightMultiplier = 0;
  static double widthMultiplier = 0;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    _blockWidth = _screenWidth / 100;
    _blockHeight = _screenHeight / 100;

    textMultiplier = _blockHeight;
    imageSizeMultiplier = _blockWidth;

    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;
    maxWidth = constraints.maxWidth;
    maxHeight = constraints.maxHeight;
  }
}
