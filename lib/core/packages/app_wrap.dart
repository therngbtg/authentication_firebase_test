import 'package:authentication_firebase_test/core/constants/constants.dart';
import 'package:authentication_firebase_test/core/packages/app_text_form_field.dart';
import 'package:flutter/material.dart';

class AppWrap extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const AppWrap({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??const EdgeInsets.symmetric(vertical: AppSize.kAppDefaultPadding/2),
      child: child,
    );
  }
}
