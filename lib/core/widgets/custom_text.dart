// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.decoration,
  });

  final String text;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: maxLines ?? 5,
      overflow: TextOverflow.ellipsis,
      textScaler: TextScaler.linear(1.0),
      textAlign: textAlign,
      text,
      style: TextStyle(
        fontFamily: fontFamily ?? AppFonts.originalSurfer,
        fontSize: fontSize ?? 13.sp,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: color ?? AppColors.whiteColor,
        decoration: decoration,
      ),
    );
  }
}
