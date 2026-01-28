import 'package:animooo/core/resources/app_assets.dart';
import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class NoItems extends StatelessWidget {
  const NoItems({
    super.key,
    this.title = "No Categories Found",
    this.subtitle = "There is no Category to display.",
  });
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Gap(AppHeight.h10),
        SvgPicture.asset(AppAssets.noItems),
        Gap(AppHeight.h6),
        CustomText(
          text: title,
          fontSize: AppFontSize.f12,
          color: AppColors.blackColor,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.poppins,
        ),
        Gap(AppHeight.h3),
        CustomText(
          text: subtitle,
          fontSize: AppFontSize.f12,
          color: AppColors.blackColor,
          fontWeight: FontWeight.w500,
          fontFamily: AppFonts.poppins,
        ),
        Gap(AppHeight.h10),
      ],
    );
  }
}
