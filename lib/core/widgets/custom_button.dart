import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final String? textFontFamily;
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final double? elevation;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final Color? textColor;
  final Widget? widget;
  final bool? isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height,
    this.width,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textColor,
    this.borderRadius,
    this.widget,
    this.elevation,
    this.textFontFamily,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsetsGeometry.symmetric(
        vertical: AppPadding.ph8,
        horizontal: AppPadding.pw8,
      ),
      elevation: elevation,
      height: height ?? AppHeight.h40,
      color: color ?? AppColors.primary,
      minWidth: isLoading ?? false ? null : width ?? double.infinity,
      onPressed: onPressed,
      shape: isLoading ?? false
          ? CircleBorder()
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.r5),
            ),
      child: isLoading ?? false
          ? CircularProgressIndicator(color: AppColors.whiteColor)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: text,
                  fontSize: fontSize ?? AppFontSize.f14,
                  fontWeight: fontWeight ?? FontWeight.w400,
                  color: textColor ?? AppColors.whiteColor,
                  fontFamily: textFontFamily ?? AppFonts.poppins,
                ),
                Gap(widget == null ? 0 : AppHeight.h15),
                if (widget != null) widget!,
              ],
            ),
    );
  }
}
