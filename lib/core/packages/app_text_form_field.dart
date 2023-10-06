import 'package:flutter/material.dart';

import '../constants/constants.dart';

class AppTextFormField extends StatelessWidget {
  final String? label;
  final String hintText;
  final String? validator;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final IconButton? suffixIcon;
  final Icon? prefixIcon;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool readOnly;
  final int? maxLines;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool? isMobile;
  final Function(String)? onChanged;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final TextAlign? textAlign;

  const AppTextFormField({
    Key? key,
    required this.hintText,
    this.label,
    this.validator,
    this.textInputType,
    this.controller,
    this.suffixIcon,
    this.obscureText,
    this.prefixIcon,
    this.keyboardType,
    this.textInputAction,
    this.readOnly = false,
    this.maxLines,
    this.fontSize = 14,
    this.fontWeight,
    this.isMobile = true,
    this.onChanged,
    this.borderRadius,
    this.borderSide,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textAlign: textAlign ?? TextAlign.start,
      textInputAction: textInputAction,
      obscureText: obscureText ?? false,
      validator: validator == null
          ? null
          : (String? val) {
              if (val!.isEmpty) {
                // showBarModalBottomSheet(
                //     bounce: true,
                //     context: context,
                //     builder: (context) {
                //       return AppBarModalDialog(
                //         isMobile: isMobile,
                //         description: "Please $hintText",
                //       );
                //     });
                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return AppAlertDialog(
                //       description: "Please $hintText",
                //       btnNameRight: "OK",
                //       onTapRight: () {
                //         Navigator.pop(context);
                //       },
                //     );
                //   },
                // );
                return validator;
              }
              return null;
            },
      readOnly: readOnly,
      onChanged: onChanged,
      cursorColor: AppColors.kDarkBlue,
      style: Theme.of(context).textTheme.bodyLarge,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius ??
              const BorderRadius.all(
                Radius.circular(5),
              ),
          borderSide: BorderSide(
            color: AppColors.kPrimaryLight,
            width: 1,
          ),
        ),
        fillColor: AppColors.kPrimaryLight,
        filled: true,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius:
              borderRadius ?? BorderRadius.circular(AppSize.kAppDefaultRadius),
          borderSide: borderSide ??
              BorderSide(
                width: 1,
                style: BorderStyle.solid,
                color: AppColors.kPrimaryLight,
              ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: borderSide ??
              BorderSide(
                color: AppColors.kPrimaryLight,
              ),
          borderRadius: borderRadius ??
              BorderRadius.circular(
                AppSize.kAppDefaultRadius,
              ),
        ),
        hintStyle:Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.kTextGreyColor),
        // border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSize.kAppDefaultPadding * 2,
          vertical: isMobile == true
              ? AppSize.kAppDefaultPadding * 2
              : AppSize.kAppDefaultPadding * 3,
        ),
      ),
    );
  }
}

