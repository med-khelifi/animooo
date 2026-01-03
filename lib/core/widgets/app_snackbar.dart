import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AppSnackBar {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static void showError(
      BuildContext context, {
        required String message,
      }) {
    messengerKey?.currentState?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r12),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: AppPadding.pw18,
          vertical: AppPadding.ph18,
        ),
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.whiteColor),
            Gap(AppWidth.w12),
            Expanded(
              child: CustomText(
                text: message,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showSuccess(
      BuildContext context, {
        required String message,
      }) {
    messengerKey?.currentState?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r12),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: AppPadding.pw18,
          vertical: AppPadding.ph18,
        ),
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline,
                color: AppColors.whiteColor),
            Gap(AppWidth.w12),
            Expanded(
              child: CustomText(
                text: message,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showNoInternet(BuildContext context) {
    messengerKey?.currentState?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r12),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: AppPadding.pw18,
          vertical: AppPadding.ph18,
        ),
        duration: const Duration(seconds: 4),
        content: Row(
          children: [
            const Icon(Icons.wifi_off, color: AppColors.whiteColor),
            Gap(AppWidth.w12),
            const Expanded(
              child: CustomText(
                text: "No internet connection",
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showInternetBack(BuildContext context) {
    messengerKey?.currentState?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r12),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: AppPadding.pw18,
          vertical: AppPadding.ph18,
        ),
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            const Icon(Icons.wifi, color: AppColors.whiteColor),
            Gap(AppWidth.w12),
            const Expanded(
              child: CustomText(
                text: "Internet connection restored",
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

