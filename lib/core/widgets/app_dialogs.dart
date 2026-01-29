import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/widgets/custom_button.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AppDialogs {
  static Future<bool?> showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true, // Allow dismissing by tapping outside
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.r12),
          ),
          child: Container(
            padding: EdgeInsets.all(AppPadding.pw18),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(AppRadius.r12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                CustomText(
                  text: "Delete Category",
                  color: AppColors.blackColor,
                  fontSize: AppFontSize.f20,
                  fontFamily: AppFonts.otamaEp,
                ),
                Gap(AppHeight.h10),

                // Message
                CustomText(
                  text: "Are you sure you want to delete this category?",
                  fontSize: AppFontSize.f14,
                  color: AppColors.blackColor,
                  fontFamily: AppFonts.otamaEp,
                  textAlign: TextAlign.center,
                ),
                Gap(AppHeight.h20),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel Button
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: CustomText(
                        text: "Cancel",
                        color: AppColors.blackColor,
                        fontSize: AppFontSize.f14,
                        fontFamily: AppFonts.otamaEp,
                      ),
                    ),
                    Gap(AppWidth.w10),

                    // Delete Button
                    CustomButton(
                      text: "Delete",
                      color: AppColors.red,
                      onPressed: () => Navigator.pop(dialogContext, true),
                      width: AppWidth.w72,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
