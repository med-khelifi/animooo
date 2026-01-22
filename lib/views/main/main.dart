import "package:animooo/controllers/main_view_controller.dart";
import "package:animooo/core/di/injection.dart";
import "package:animooo/views/main/animal_view.dart";
import "package:animooo/views/main/category_view.dart";
import "package:animooo/views/main/home_view.dart";
import "package:animooo/views/main/profile_view.dart";
import "package:animooo/views/main/search_view.dart";
import "package:animooo/views/main/widgets/main_view_bottom_navbar.dart";
import "package:flutter/material.dart";

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  late MainViewController _mainViewController;
  @override
  void initState() {
    super.initState();
    _mainViewController = services<MainViewController>();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _mainViewController.currentIndexStream,
      builder: (context, asyncSnapshot) {
        return Scaffold(
          bottomNavigationBar: MainViewBottomNavbar(
            currentIndex: asyncSnapshot.data ?? 0,
            onTap: _mainViewController.onChangeIndex,
          ),
          body: SafeArea(
            child: IndexedStack(
              index: asyncSnapshot.data ?? 0,
              children: [
                HomeView(),
                SearchView(),
                CategoryView(),
                AnimalView(),
                ProfileView(),
              ],
            ),
          ),
        );
      },
    );
  }
}
