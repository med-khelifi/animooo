import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/resources/app_strings.dart';
import 'package:animooo/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BottomSheets {
  static Future<void> showTakeImageBottomSheet(
    BuildContext context, {
    VoidCallback? onCancelPressed,
    VoidCallback? onTakeFromCameraPressed,
    VoidCallback? onTakeFromGalleryPressed,
  }) async {
    showModalBottomSheet(
      backgroundColor: AppColors.transparent,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.pw10,
            vertical: AppPadding.ph10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppRadius.r10),
                  ),
                  color: AppColors.whiteColor,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CustomButton(
                      text: AppStrings.takeImageFromGallery,
                      textFontFamily: AppFonts.otamaEp,
                      fontSize: AppFontSize.f16,
                      elevation: 0,
                      color: AppColors.whiteColor,
                      textColor: AppColors.primary,
                      onPressed:() {
                        if(onTakeFromGalleryPressed != null) onTakeFromGalleryPressed();
                        Navigator.pop(context);
                      },
                    ),
                    CustomButton(
                      text: AppStrings.takeImageFromCamera,
                      textFontFamily: AppFonts.otamaEp,
                      fontSize: AppFontSize.f16,
                      elevation: 0,
                      color: AppColors.whiteColor,
                      textColor: AppColors.primary,
                      onPressed: () {
                        if(onTakeFromCameraPressed != null) onTakeFromCameraPressed();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Gap(AppHeight.h15),
              CustomButton(
                text: AppStrings.cancel,
                textFontFamily: AppFonts.otamaEp,
                fontSize: AppFontSize.f16,
                elevation: 0,
                color: AppColors.whiteColor,
                textColor: AppColors.primary,
                onPressed: onCancelPressed ?? () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
