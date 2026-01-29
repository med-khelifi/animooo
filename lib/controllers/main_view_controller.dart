import 'dart:async';
import 'dart:io';

import 'package:animooo/core/di/injection.dart';
import 'package:animooo/core/enums/image_picker_state.dart';
import 'package:animooo/core/enums/view_mode.dart';
import 'package:animooo/core/requests/create_new_category_request.dart';
import 'package:animooo/core/requests/update_category_request.dart';
import 'package:animooo/core/utils/image_picker_utils.dart';
import 'package:animooo/core/widgets/app_dialogs.dart';
import 'package:animooo/core/widgets/app_snackbar.dart';
import 'package:animooo/core/widgets/bottom_sheets.dart';
import 'package:animooo/models/animal_model.dart';
import 'package:animooo/models/category_model.dart';
import 'package:animooo/services/animal_service.dart';
import 'package:animooo/services/category_service.dart';
import 'package:flutter/material.dart';

enum ImageTarget { category, animal }

class MainViewController {
  MainViewController() {
    _categoryTabButtonTextStreamBuilder.add("Add New Category");
  }

  var _categoryTabViewMode = ViewMode.addNew;

  // ============================================================================
  // NAVIGATION
  // ============================================================================

  final StreamController<int> _currentIndexController =
      StreamController<int>.broadcast();
  final GlobalKey<NavigatorState> homeNavigationKey =
      GlobalKey<NavigatorState>();

  Stream<int> get currentIndexStream => _currentIndexController.stream;

  // ============================================================================
  // FORMS
  // ============================================================================

  final GlobalKey<FormState> categoryFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> animalFormKey = GlobalKey<FormState>();

  // ============================================================================
  // TEXT CONTROLLERS
  // ============================================================================

  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController categoryDescriptionController =
      TextEditingController();
  final TextEditingController animalNameController = TextEditingController();
  final TextEditingController animalDescriptionController =
      TextEditingController();
  final TextEditingController animalPriceController = TextEditingController();
  final TextEditingController animalCategoryController =
      TextEditingController();

  // ============================================================================
  // IMAGE STREAMS
  // ============================================================================

  final StreamController<(ImagePickerState state, File? imageFile)>
  categoryImageStreamController =
      StreamController<(ImagePickerState, File?)>.broadcast();

  final StreamController<(ImagePickerState state, File? imageFile)>
  animalImageStreamController =
      StreamController<(ImagePickerState, File?)>.broadcast();

  Stream<(ImagePickerState state, File? imageFile)> get categoryImageStream =>
      categoryImageStreamController.stream;

  Stream<(ImagePickerState state, File? imageFile)> get animalImageStream =>
      animalImageStreamController.stream;

  ImagePickerState _categoryImageState = ImagePickerState.none;
  ImagePickerState _animalImageState = ImagePickerState.none;
  File? _categoryImageFile;
  File? _animalImageFile;

  // Store network URLs separately to avoid File(networkUrl) crash
  String? _categoryNetworkImageUrl;
  String? _animalNetworkImageUrl;

  CategoryModel? _categoryToEdit;
  bool _isCategoryImageChanged = false;

  // ============================================================================
  // BUTTON LOADING STREAMS
  // ============================================================================

  final StreamController<bool> _isDeleteCategoryButtonVisibleStreamController =
      StreamController<bool>.broadcast();
  Stream<bool> get isDeleteCategoryButtonVisibleStream =>
      _isDeleteCategoryButtonVisibleStreamController.stream;

  bool _isDeleteCategoryButtonLoading = false;
  final StreamController<bool> _isDeleteCategoryButtonLoadingStreamController =
      StreamController<bool>.broadcast();
  Stream<bool> get isDeleteCategoryButtonLoadingStream =>
      _isDeleteCategoryButtonLoadingStreamController.stream;

  // ============================================================================
  // BUTTON TEXT STREAMS
  // ============================================================================

  final StreamController<String> _categoryTabButtonTextStreamBuilder =
      StreamController<String>.broadcast();
  Stream<String> get categoryTabButtonTextStream =>
      _categoryTabButtonTextStreamBuilder.stream;

  final StreamController<bool> _isAddCategoryButtonLoadingStreamController =
      StreamController<bool>.broadcast();

  final StreamController<bool> _isAddAnimalButtonLoadingStreamController =
      StreamController<bool>.broadcast();

  Stream<bool> get isAddCategoryButtonEnabledStream =>
      _isAddCategoryButtonLoadingStreamController.stream;

  Stream<bool> get isAddAnimalButtonEnabledStream =>
      _isAddAnimalButtonLoadingStreamController.stream;

  bool _isAddCategoryButtonLoading = false;
  bool _isAddAnimalButtonLoading = false;

  // ============================================================================
  // CATEGORIES STREAM
  // ============================================================================

  final StreamController<List<CategoryModel>> _categoriesStreamController =
      StreamController<List<CategoryModel>>.broadcast();

  Stream<List<CategoryModel>> get categoriesStream =>
      _categoriesStreamController.stream;

  final StreamController<List<AnimalModel>> _animalsStreamController =
      StreamController<List<AnimalModel>>.broadcast();

  Stream<List<AnimalModel>> get animalsStream =>
      _animalsStreamController.stream;

  List<CategoryModel> _categories = [];
  List<AnimalModel> _animals = [];

  final StreamController<bool> _isLoadingCategoriesStreamController =
      StreamController<bool>.broadcast();

  Stream<bool> get isLoadingCategoriesStream =>
      _isLoadingCategoriesStreamController.stream;

  // ✅ FIX: Add separate loading stream for animals
  final StreamController<bool> _isLoadingAnimalsStreamController =
      StreamController<bool>.broadcast();

  Stream<bool> get isLoadingAnimalsStream =>
      _isLoadingAnimalsStreamController.stream;

  // ============================================================================
  // NAVIGATION METHODS
  // ============================================================================

  void onChangeIndex(int index) {
    _currentIndexController.add(index);
  }

  void goBackToHome() {
    _resetCategoryTab();
    _categoryTabViewMode = ViewMode.addNew;
    _categoryTabButtonTextStreamBuilder.add("Add New Category");
    _isDeleteCategoryButtonVisibleStreamController.add(false);
    onChangeIndex(0);
  }

  void goToAddCategory() {
    onChangeIndex(2);
    _isDeleteCategoryButtonVisibleStreamController.add(false);
  }

  void goToAddAnimal() {
    onChangeIndex(3);
  }

  // ============================================================================
  // IMAGE PICKING
  // ============================================================================

  void onTakeImagePressed(BuildContext context, ImageTarget target) async {
    BottomSheets.showTakeImageBottomSheet(
      context,
      onTakeFromCameraPressed: () async {
        final file = await ImagePickerUtils.takeImageCamera();
        _handlePickedImage(file, target);
      },
      onTakeFromGalleryPressed: () async {
        final file = await ImagePickerUtils.takeImageGallery();
        _handlePickedImage(file, target);
      },
    );
  }

  void _handlePickedImage(File? file, ImageTarget target) {
    if (file == null) return;

    if (target == ImageTarget.category) {
      _categoryImageFile = file;
      _categoryImageState = ImagePickerState.picked;
      _isCategoryImageChanged = true;
      _categoryNetworkImageUrl =
          null; // Clear network URL when picking new image
      categoryImageStreamController.add((_categoryImageState, file));
    } else {
      _animalImageFile = file;
      _animalImageState = ImagePickerState.picked;
      _animalNetworkImageUrl = null;
      animalImageStreamController.add((_animalImageState, file));
    }
  }

  // ============================================================================
  // VALIDATION
  // ============================================================================

  String? validateCategoryName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Category name is required";
    }
    if (value.trim().length < 3) {
      return "Category name must be at least 3 characters";
    }
    return null;
  }

  String? validateCategoryDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Category description is required";
    }
    if (value.trim().length < 10) {
      return "Description must be at least 10 characters";
    }
    return null;
  }

  String? validateAnimalPrice(String? value) {
    if (value == null || value.trim().isEmpty) return "Price is required";
    final price = double.tryParse(value);
    if (price == null) return "Invalid price format";
    if (price <= 0) return "Price must be greater than 0";
    return null;
  }

  String? validateAnimalName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Animal name is required";
    }
    return null;
  }

  String? validateAnimalDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Animal description is required";
    }
    return null;
  }

  // ============================================================================
  // CATEGORY OPERATIONS
  // ============================================================================

  void onAddEditCategoryPressed(BuildContext context) async {
    if (_categoryTabViewMode == ViewMode.addNew) {
      await addNewCategory(context);
    } else {
      await editCategory(context);
    }
  }

  Future<void> addNewCategory(BuildContext context) async {
    if (_isAddCategoryButtonLoading) return;
    if (!categoryFormKey.currentState!.validate()) return;

    // For new category, image is required
    if (_categoryImageState == ImagePickerState.none ||
        _categoryImageFile == null) {
      _categoryImageState = ImagePickerState.error;
      categoryImageStreamController.add((ImagePickerState.error, null));
      return;
    }

    if (_categoryImageState == ImagePickerState.error) {
      categoryImageStreamController.add((ImagePickerState.error, null));
      return;
    }

    final categoryService = services<CategoryService>();

    _isAddCategoryButtonLoading = true;
    _isAddCategoryButtonLoadingStreamController.add(
      _isAddCategoryButtonLoading,
    );

    final res = await categoryService.registerNewCategory(
      createCategoryRequest: CreateNewCategoryRequest(
        name: categoryNameController.text.trim(),
        description: categoryDescriptionController.text.trim(),
        image: _categoryImageFile!.path,
      ),
    );

    _isAddCategoryButtonLoading = false;
    _isAddCategoryButtonLoadingStreamController.add(
      _isAddCategoryButtonLoading,
    );

    if (res.isSuccess) {
      // Reset form first
      _resetCategoryTab();

      // Update categories list
      _categories.insert(0, res.data!);
      _categoriesStreamController.add(_categories);

      // Show success message
      if (context.mounted) {
        AppSnackBar.showSuccess(
          context,
          message: res.alert ?? "Category added successfully",
        );
      }

      // Navigate back to home
      goBackToHome();
    } else {
      String? message =
          res.error?.errors?.join('\n') ??
          res.error?.message ??
          "Error adding category";
      if (context.mounted) {
        AppSnackBar.showError(context, message: message);
      }
    }
  }

  Future<void> editCategory(BuildContext context) async {
    if (_isAddCategoryButtonLoading) return;
    if (!categoryFormKey.currentState!.validate()) return;

    // For edit mode, image is optional
    if (_categoryImageState == ImagePickerState.error) {
      categoryImageStreamController.add((ImagePickerState.error, null));
      return;
    }

    final categoryService = services<CategoryService>();

    _isAddCategoryButtonLoading = true;
    _isAddCategoryButtonLoadingStreamController.add(
      _isAddCategoryButtonLoading,
    );

    String? imagePath;
    if (_isCategoryImageChanged && _categoryImageFile != null) {
      // User picked a new image - send the local file path
      imagePath = _categoryImageFile!.path;
    }
    // If not changed, send null and backend will keep existing image

    final res = await categoryService.updateCategory(
      updateCategoryRequest: UpdateCategoryRequest(
        id: _categoryToEdit!.id,
        name: categoryNameController.text.trim(),
        description: categoryDescriptionController.text.trim(),
        image: imagePath, // null means keep existing image
      ),
    );

    _isAddCategoryButtonLoading = false;
    _isAddCategoryButtonLoadingStreamController.add(
      _isAddCategoryButtonLoading,
    );

    if (res.isSuccess) {
      // Update the category in the list
      final index = _categories.indexWhere(
        (cat) => cat.id == _categoryToEdit!.id,
      );
      if (index != -1) {
        _categories[index] = res.data!;
        _categoriesStreamController.add(_categories);
      }

      // Show success message
      if (context.mounted) {
        AppSnackBar.showSuccess(
          context,
          message: res.alert ?? "Category updated successfully",
        );
      }

      // Navigate back to home (this will also reset the form)
      goBackToHome();
    } else {
      String? message =
          res.error?.errors?.join('\n') ??
          res.error?.message ??
          "Error updating category";
      if (context.mounted) {
        AppSnackBar.showError(context, message: message);
      }
    }
  }

  Future<void> getAllCategories(BuildContext context) async {
    final categoryService = services<CategoryService>();

    _isLoadingCategoriesStreamController.add(true);

    final res = await categoryService.getAllCategories();

    _isLoadingCategoriesStreamController.add(false);

    if (res.isSuccess) {
      _categories = res.data ?? [];
      _categoriesStreamController.add(_categories);
    } else {
      String message =
          res.error?.errors?.join('\n') ??
          res.error?.message ??
          "Error loading categories";
      if (context.mounted) {
        AppSnackBar.showError(context, message: message);
      }
    }
  }

  Future<void> getAllAnimals(BuildContext context) async {
    final animalsService = services<AnimalService>();

    // ✅ FIX: Use correct loading stream for animals
    _isLoadingAnimalsStreamController.add(true);

    final res = await animalsService.getAllAnimals();

    _isLoadingAnimalsStreamController.add(false);

    if (res.isSuccess) {
      _animals = res.data ?? [];
      _animalsStreamController.add(_animals);
    } else {
      String message =
          res.error?.errors?.join('\n') ??
          res.error?.message ??
          "Error loading animals";
      if (context.mounted) {
        AppSnackBar.showError(context, message: message);
      }
    }
  }

  void onDeleteCategoryPressed(BuildContext context) async {
    if (_categoryToEdit == null) return;
    if (_isDeleteCategoryButtonLoading == true) return;

    bool? isDelete = await AppDialogs.showDeleteDialog(context);
    if (isDelete != true) return;

    final categoryService = services<CategoryService>();

    _isDeleteCategoryButtonLoading = true;
    _isDeleteCategoryButtonLoadingStreamController.add(
      _isDeleteCategoryButtonLoading,
    );

    final res = await categoryService.deleteCategory(id: _categoryToEdit!.id);

    _isDeleteCategoryButtonLoading = false;
    _isDeleteCategoryButtonLoadingStreamController.add(
      _isDeleteCategoryButtonLoading,
    );
    if (res.isSuccess) {
      // Remove from list
      _categories.removeWhere((cat) => cat.id == _categoryToEdit!.id);
      _categoriesStreamController.add(_categories);
      _resetCategoryTab();
      if (context.mounted) {
        AppSnackBar.showSuccess(
          context,
          message: res.alert ?? "Category deleted successfully",
        );
      }

      goBackToHome();
    } else {
      String message =
          res.error?.errors?.join('\n') ??
          res.error?.message ??
          "Error deleting category";
      if (context.mounted) {
        AppSnackBar.showError(context, message: message);
      }
    }
  }

  // ============================================================================
  // ANIMAL OPERATIONS
  // ============================================================================

  void onAddAnimalPressed() {
    if (!animalFormKey.currentState!.validate()) return;
    // TODO: Implement animal addition logic
  }

  // ============================================================================
  // DISPOSAL
  // ============================================================================

  void dispose() {
    // Close streams
    _currentIndexController.close();
    categoryImageStreamController.close();
    animalImageStreamController.close();
    _isAddCategoryButtonLoadingStreamController.close();
    _isAddAnimalButtonLoadingStreamController.close();
    _categoriesStreamController.close();
    _animalsStreamController.close();
    _isLoadingCategoriesStreamController.close();
    _isLoadingAnimalsStreamController
        .close(); // ✅ FIX: Close animals loading stream
    _categoryTabButtonTextStreamBuilder.close();
    _isDeleteCategoryButtonVisibleStreamController.close();

    // Dispose controllers
    categoryNameController.dispose();
    categoryDescriptionController.dispose();
    animalNameController.dispose();
    animalDescriptionController.dispose();
    animalPriceController.dispose();
    animalCategoryController.dispose();
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Fills the category form with existing category data for editing
  void fillCategoryData(CategoryModel categoryModel) {
    categoryNameController.text = categoryModel.name;
    categoryDescriptionController.text = categoryModel.description;

    // ✅ FIX: Store network URL instead of creating File from network path
    _categoryNetworkImageUrl = categoryModel.imagePath;
    _categoryImageFile = File(categoryModel.imagePath); // No local file
    _categoryImageState = ImagePickerState.picked;
    _isCategoryImageChanged = false; // Image not changed yet, just loaded

    categoryImageStreamController.add((
      _categoryImageState,
      _categoryImageFile, // Don't send File for network images
    ));
  }

  /// Called when a category item is tapped for editing
  void onCategoryItemTapped(CategoryModel categoryModel) {
    _categoryTabViewMode = ViewMode.edit;
    _categoryTabButtonTextStreamBuilder.add("Edit Category");
    _categoryToEdit = categoryModel;
    fillCategoryData(categoryModel);
    goToAddCategory();
    _isDeleteCategoryButtonVisibleStreamController.add(true);
  }

  /// Resets the category form to initial state
  void _resetCategoryTab() {
    categoryNameController.text = "";
    categoryDescriptionController.text = "";
    _categoryImageFile = null;
    _categoryNetworkImageUrl = null; // ✅ FIX: Clear network URL
    _categoryImageState = ImagePickerState.none;
    _isCategoryImageChanged = false;
    _categoryToEdit = null;
    categoryImageStreamController.add((_categoryImageState, null));
    categoryFormKey.currentState?.reset();
  }

  (bool, dynamic) getCategoryImageData() {
    if (_categoryImageFile != null) {
      return (false, _categoryImageFile); // Local file
    } else if (_categoryNetworkImageUrl != null) {
      return (true, _categoryNetworkImageUrl); // Network URL
    }
    return (false, null); // No image
  }

  (bool, dynamic) getAnimalImageData() {
    if (_animalImageFile != null) {
      return (false, _animalImageFile);
    } else if (_animalNetworkImageUrl != null) {
      return (true, _animalNetworkImageUrl);
    }
    return (false, null);
  }
}
