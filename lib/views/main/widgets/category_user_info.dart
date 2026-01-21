import 'package:animooo/core/resources/app_assets.dart';
import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class CategoryUserInfo extends StatelessWidget {
  const CategoryUserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.r20),
          child: Image.network(
            "https://images.unsplash.com/photo-1511485977113-f34c92461ad9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80",
            width: AppWidth.w37,
            height: AppHeight.h37,
            fit: BoxFit.cover,
          ),
        ),
        Gap(AppWidth.w6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Ahmed Elkhelifi",
              fontSize: AppFontSize.f12,
              fontFamily: AppFonts.poppins,
              color: AppColors.blackColor,
            ),
            _statusContainer(),
          ],
        ),
      ],
    );
  }

  Container _statusContainer() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.pw5,
        vertical: AppPadding.ph5,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightGreenWhiteColor,
        borderRadius: BorderRadius.circular(AppRadius.r20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppAssets.globePlanet,
            height: AppHeight.h8,
            width: AppWidth.w9,
          ),
          Gap(AppWidth.w5),
          CustomText(
            text: "Public",
            fontSize: AppFontSize.f10,
            fontFamily: AppFonts.poppins,
            color: AppColors.lightGreenColor,
          ),
        ],
      ),
    );
  }
}
