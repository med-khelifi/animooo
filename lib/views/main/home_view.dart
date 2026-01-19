import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/widgets/app_logo.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:animooo/views/main/widgets/category_list.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.pw10),
      child: Column(
        children: [
          Row(
            children: [
              AppLogo(),
              Spacer(),
              CustomText(
                text: "Hello in Animooo",
                color: AppColors.primary,
                fontSize: AppFontSize.f24,
              ),
              Spacer(),
            ],
          ),
          Row(
            children: [
              CustomText(
                text: "Categories ( 10 )",
                color: AppColors.primary,
                fontSize: AppFontSize.f16,
                fontFamily: AppFonts.poppins,
              ),
              Spacer(),
              CustomText(
                text: "Add New Category",
                color: AppColors.primary,
                fontSize: AppFontSize.f16,
                fontFamily: AppFonts.poppins,
              ),
            ],
          ),
          CategoryList(),
          Row(
            children: [
              CustomText(
                text: "All Animals ( 10 )",
                color: AppColors.primary,
                fontSize: AppFontSize.f16,
                fontFamily: AppFonts.poppins,
              ),
              Spacer(),
              CustomText(
                text: "Add New Animal",
                color: AppColors.primary,
                fontSize: AppFontSize.f16,
                fontFamily: AppFonts.poppins,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
