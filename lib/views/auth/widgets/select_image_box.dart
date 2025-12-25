import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/resources/app_strings.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class SelectImageBox extends StatelessWidget {
  const SelectImageBox({super.key, this.onTap, this.isError});
  final void Function()? onTap;
  final bool? isError;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          color: isError ?? false ? AppColors.red : AppColors.primary,
          dashPattern: [5, 5],
          radius: Radius.circular(AppRadius.r10),
        ),
        child: SizedBox(
          height: AppHeight.h130,
          width: double.infinity,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.image,
                  color: isError ?? false ? AppColors.red : AppColors.primary,
                  size: AppFontSize.f50,
                ),
                CustomText(
                  text: AppStrings.selectFile,
                  fontFamily: AppFonts.poppins,
                  fontSize: AppFontSize.f14,
                  color: isError ?? false ? AppColors.red : AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

