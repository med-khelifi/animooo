import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CategoryListItem extends StatelessWidget {
  const CategoryListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(AppRadius.r60),
              child: Image.network(
                "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1280px-Image_created_with_a_mobile_phone.png",
                height: AppHeight.h64,
                width: AppWidth.w64,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                height: AppHeight.h20,
                width: AppWidth.w20,
                decoration: ShapeDecoration(
                  color: AppColors.primary,
                  shape: CircleBorder(),
                ),
                child: CustomText(text: "1", color: AppColors.whiteColor),
              ),
            ),
          ],
        ),
        CustomText(
          text: "Cats",
          fontSize: AppFontSize.f16,
          color: AppColors.blackColor,
        ),
      ],
    );
  }
}
