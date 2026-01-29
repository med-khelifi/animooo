import 'dart:async';

import 'package:flutter/material.dart';

/// Handles main view tab navigation
class MainViewController {
  MainViewController() {
    _currentIndexController.add(0); // Start at home
  }

  // ============================================================================
  // NAVIGATION STATE
  // ============================================================================

  final StreamController<int> _currentIndexController =
      StreamController<int>.broadcast();

  final GlobalKey<NavigatorState> homeNavigationKey =
      GlobalKey<NavigatorState>();

  Stream<int> get currentIndexStream => _currentIndexController.stream;

  int _currentIndex = 0;

  // ============================================================================
  // NAVIGATION METHODS
  // ============================================================================

  /// Changes the current tab index
  void onChangeIndex(int index) {
    _currentIndex = index;
    _currentIndexController.add(index);
  }

  /// Navigate to home tab
  void goToHome() {
    onChangeIndex(0);
  }

  /// Navigate to add category tab
  void goToAddCategory() {
    onChangeIndex(2);
  }

  /// Navigate to add animal tab
  void goToAddAnimal() {
    onChangeIndex(3);
  }

  /// Get current tab index
  int getCurrentIndex() => _currentIndex;

  // ============================================================================
  // DISPOSAL
  // ============================================================================

  void dispose() {
    _currentIndexController.close();
  }
}
