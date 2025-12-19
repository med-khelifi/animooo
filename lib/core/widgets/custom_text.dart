import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.color,
    this.maxLines,
    this.fontFamily,
    this.underLined,
  });

  final String text;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool? underLined;

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
        decoration: underLined ?? false ? TextDecoration.underline : null,
      ),
    );
  }
}
