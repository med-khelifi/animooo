import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.isPassword,
    required this.hint,
    this.label,
  });
  final bool? isPassword;
  final String? label;
  final String hint;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          CustomText(
            text: label!,
            color: AppColors.secondary,
            fontSize: AppFontSize.f18,
            fontFamily: AppFonts.poppins,
          ),
        Gap(label == null ? AppHeight.h0 : AppHeight.h6),
        TextFormField(
          decoration: InputDecoration(
            suffixIcon: isPassword == true
                ? const Icon(CupertinoIcons.eye, color: AppColors.textHint)
                : null,
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textHint),
            fillColor: AppColors.lightGrey,
            filled: true,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.r10)),
              borderSide: BorderSide(color: AppColors.red),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.r10)),
              borderSide: BorderSide(color: AppColors.secondary),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.r10)),
            ),
          ),
        ),
      ],
    );
  }
}
