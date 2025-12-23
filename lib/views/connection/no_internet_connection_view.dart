import 'package:animooo/core/resources/app_assets.dart';
import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class NoInternetConnectionView extends StatelessWidget {
  const NoInternetConnectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.noInternetConnectionSVG,
              height: AppHeight.h230,
            ),
            Gap(AppHeight.h10),
            CustomText(
              text: "No Internet Connection Found!",
              color: AppColors.secondary,
              fontFamily: AppFonts.poppins,
              fontSize: AppFontSize.f14,
              fontWeight: FontWeight.w600,
            ),
            Gap(AppHeight.h10),
            CustomText(
              text:
                  "Unable to connect to the internet. Please check your connection and try again.",
              fontFamily: AppFonts.poppins,
              fontSize: AppFontSize.f14,
              color: AppColors.secondary,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
