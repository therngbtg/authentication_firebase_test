import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants/constants.dart';
class AppLoading extends StatelessWidget {
  final Widget? child;
  final bool? isLoading;

  const AppLoading({
    Key? key,
    this.child,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        progressIndicator: SpinKitSpinningLines(color: AppColors.kDarkGreen),
        opacity: 0.5,
        blur: 5.0,
        inAsyncCall: isLoading!,
        child: child!);
  }
}
