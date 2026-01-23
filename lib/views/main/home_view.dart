import 'package:animooo/controllers/main_view_controller.dart';
import 'package:animooo/core/di/injection.dart';
import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_routes.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/widgets/app_logo.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:animooo/views/main/all_categories_view.dart';
import 'package:animooo/views/main/widgets/animals_list.dart';
import 'package:animooo/views/main/widgets/category_list.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late MainViewController _mainViewController;
  @override
  void initState() {
    super.initState();
    _mainViewController = services<MainViewController>();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.pw18),
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
                Gap(AppHeight.h10),
                Row(
                  children: [
                    CustomText(
                      text: "Categories ( 10 )",
                      color: AppColors.primary,
                      fontSize: AppFontSize.f16,
                      fontFamily: AppFonts.poppins,
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        _mainViewController.goToAddCategory();
                      },
                      child: CustomText(
                        text: "Add New Category",
                        color: AppColors.blackColor,
                        fontSize: AppFontSize.f16,
                        fontFamily: AppFonts.poppins,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverGap(AppHeight.h20),
        CategoryList(),
        SliverGap(AppHeight.h20),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.pw18),
            child: Row(
              children: [
                CustomText(
                  text: "All Animals ( 10 )",
                  color: AppColors.blackColor,
                  fontSize: AppFontSize.f16,
                  fontFamily: AppFonts.poppins,
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    _mainViewController.goToAddAnimal();
                  },
                  child: CustomText(
                    text: "Add New Animal",
                    color: AppColors.blackColor,
                    fontSize: AppFontSize.f16,
                    fontFamily: AppFonts.poppins,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverGap(AppHeight.h16),
        AnimalsList(),
      ],
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late MainViewController _mainViewController;
  @override
  void initState() {
    super.initState();
    _mainViewController = services<MainViewController>();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _mainViewController.homeNavigationKey,
      onGenerateRoute: (settings) {
        final routeName = settings.name;
        if (routeName == RoutesNames.mainHomeAllCategories) {
          return MaterialPageRoute(
            builder: (context) => const AllCategoriesView(),
          );
        } else {
          return MaterialPageRoute(builder: (context) => const HomeView());
        }
      },
    );
  }
}
