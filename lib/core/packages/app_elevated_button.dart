import 'package:authentication_firebase_test/core/constants/constants.dart';
import 'package:flutter/material.dart';

class ElevatedButtonApp extends StatelessWidget {
  final String? title;
  final TextStyle? style;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final bool? isMobile;
  final double? borderRadius;

  const ElevatedButtonApp({
    Key? key,
    this.title,
    this.style,
    this.onPressed,
    this.backgroundColor,
    this.isMobile,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.kPrimaryLight,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(borderRadius ?? AppSize.kAppCircleRadius),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        height: isMobile == true
            ? AppSizeConfig.heightMultiplier * 6
            : AppSizeConfig.heightMultiplier * 5,
        alignment: Alignment.center,
        width: double.infinity,
        child: Text("$title", style: style),
      ),
    );
  }
}
