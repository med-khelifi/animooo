import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:animooo/models/category_model.dart';
import 'package:flutter/material.dart';

class CategoryListItem extends StatelessWidget {
  final CategoryModel categoryModel;
  const CategoryListItem({super.key, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.pw8),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(AppRadius.r60),
                child: Image.network(
                  categoryModel.imagePath,
                  height: AppHeight.h64,
                  width: AppWidth.w64,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 0,
                right: -5,
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
            text: categoryModel.name,
            fontSize: AppFontSize.f16,
            color: AppColors.blackColor,
          ),
        ],
      ),
    );
  }
}
