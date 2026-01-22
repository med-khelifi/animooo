import "package:animooo/core/resources/app_assets.dart";
import "package:animooo/core/resources/app_colors.dart";
import "package:animooo/core/resources/app_sizes.dart";
import "package:animooo/core/resources/app_strings.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

class MainViewBottomNavbar extends StatelessWidget {
  const MainViewBottomNavbar({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });
  final ValueChanged<int> onTap;
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    final selectedColor = AppColors.primary;
    final unSelectedColor = AppColors.secondary;
    return BottomNavigationBar(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: selectedColor,
      unselectedItemColor: unSelectedColor,
      onTap: onTap,
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.pw8,
              vertical: AppPadding.ph8,
            ),
            child: SvgPicture.asset(
              AppAssets.homeNavSVG,
              color: currentIndex == 0 ? selectedColor : unSelectedColor,
            ),
          ),
          label: AppStrings.home,
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.pw8,
              vertical: AppPadding.ph8,
            ),
            child: SvgPicture.asset(
              AppAssets.searchNavSVG,
              color: currentIndex == 1 ? selectedColor : unSelectedColor,
            ),
          ),
          label: AppStrings.search,
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.pw8,
              vertical: AppPadding.ph8,
            ),
            child: SvgPicture.asset(
              AppAssets.categoryNavSVG,
              color: currentIndex == 2 ? selectedColor : unSelectedColor,
            ),
          ),
          label: AppStrings.category,
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.pw8,
              vertical: AppPadding.ph8,
            ),
            child: SvgPicture.asset(
              AppAssets.animalNavSVG,
              color: currentIndex == 3 ? selectedColor : unSelectedColor,
            ),
          ),
          label: AppStrings.animal,
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.pw8,
              vertical: AppPadding.ph8,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.pw8),
              child: SvgPicture.asset(
                AppAssets.meNavSVG,
                color: currentIndex == 4 ? selectedColor : unSelectedColor,
              ),
            ),
          ),
          label: AppStrings.me,
        ),
      ],
    );
  }
}
