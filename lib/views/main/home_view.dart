import 'package:animooo/controllers/main_view_controller.dart';
import 'package:animooo/core/di/injection.dart';
import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/widgets/app_logo.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:animooo/core/widgets/no_items.dart';
import 'package:animooo/models/animal_model.dart';
import 'package:animooo/models/category_model.dart';
import 'package:animooo/views/main/widgets/animals_list.dart';
import 'package:animooo/views/main/widgets/category_list.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final MainViewController _mainViewController;

  @override
  void initState() {
    super.initState();
    _mainViewController = services<MainViewController>();
    // Load categories when view initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mainViewController.getAllCategories(context);
      _mainViewController.getAllAnimals(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _mainViewController.getAllCategories(context);
        _mainViewController.getAllAnimals(context);
      },
      color: AppColors.primary,
      child: CustomScrollView(
        slivers: [
          // ============= Header Section =============
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.pw18),
              child: Column(
                children: [
                  Row(
                    children: [
                      const AppLogo(),
                      const Spacer(),
                      CustomText(
                        text: "Hello in Animooo",
                        color: AppColors.primary,
                        fontSize: AppFontSize.f24,
                      ),
                      const Spacer(),
                    ],
                  ),
                  Gap(AppHeight.h10),
                  _buildCategoriesHeader(),
                ],
              ),
            ),
          ),

          SliverGap(AppHeight.h20),

          // ============= Categories List =============
          StreamBuilder<List<CategoryModel>>(
            stream: _mainViewController.categoriesStream,
            builder: (context, categoriesSnapshot) {
              return StreamBuilder<bool>(
                stream: _mainViewController.isLoadingCategoriesStream,
                builder: (context, loadingSnapshot) {
                  final categories = categoriesSnapshot.data ?? [];
                  final isLoading = loadingSnapshot.data ?? false;
                  if (categories.isEmpty) {
                    return SliverToBoxAdapter(child: NoItems());
                  } else {
                    return Skeletonizer.sliver(
                      enabled: isLoading,
                      child: CategoryList(
                        onCategoryTap: _mainViewController.onCategoryItemTaped,
                        categories: categories,
                      ),
                    );
                  }
                },
              );
            },
          ),

          SliverGap(AppHeight.h20),

          // ============= Animals Section =============
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.pw18),
              child: _buildAnimalsHeader(),
            ),
          ),

          SliverGap(AppHeight.h16),

          StreamBuilder<List<AnimalModel>>(
            stream: _mainViewController.animalsStream,
            builder: (context, asyncSnapshot) {
              final animals = asyncSnapshot.data ?? [];
              if (animals.isEmpty) {
                return SliverToBoxAdapter(
                  child: NoItems(
                    title: "No Animals Found!",
                    subtitle: "There is no Animals to display.",
                  ),
                );
              }
              return AnimalsList(animals: asyncSnapshot.data ?? const []);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesHeader() {
    return StreamBuilder(
      stream: _mainViewController.categoriesStream,
      builder: (context, snapshot) {
        final categoryCount = snapshot.data?.length ?? 0;

        return Row(
          children: [
            CustomText(
              text: "Categories ($categoryCount)",
              color: AppColors.primary,
              fontSize: AppFontSize.f16,
              fontFamily: AppFonts.poppins,
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => _mainViewController.goToAddCategory(),
              child: CustomText(
                text: "Add New Category",
                color: AppColors.blackColor,
                fontSize: AppFontSize.f16,
                fontFamily: AppFonts.poppins,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnimalsHeader() {
    return StreamBuilder(
      stream: _mainViewController.animalsStream,
      builder: (context, asyncSnapshot) {
        return Row(
          children: [
            CustomText(
              text: "All Animals (${asyncSnapshot.data?.length ?? 0})",
              color: AppColors.blackColor,
              fontSize: AppFontSize.f16,
              fontFamily: AppFonts.poppins,
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => _mainViewController.goToAddAnimal(),
              child: CustomText(
                text: "Add New Animal",
                color: AppColors.blackColor,
                fontSize: AppFontSize.f16,
                fontFamily: AppFonts.poppins,
              ),
            ),
          ],
        );
      },
    );
  }
}

// ============= Home Tab Navigator =============
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late final MainViewController _mainViewController;

  @override
  void initState() {
    super.initState();
    _mainViewController = services<MainViewController>();
  }

  @override
  Widget build(BuildContext context) {
    return HomeView();
    /*
      Navigator(
      key: _mainViewController.homeNavigationKey,
      onGenerateRoute: (settings) {
        final routeName = settings.name;

        if (routeName == RoutesNames.mainHomeAllCategories) {
          return MaterialPageRoute(
            builder: (context) => const AllCategoriesView(),
          );
        }

        // Default route
        return MaterialPageRoute(builder: (context) => const );
      },
    );
     */
  }
}
