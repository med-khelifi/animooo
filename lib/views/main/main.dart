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
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MainViewBottomNavbar(
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
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
  }
}
