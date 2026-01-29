import 'dart:async';
import 'dart:io';

import 'package:animooo/controllers/main_view_controller.dart';
import 'package:animooo/core/di/injection.dart';
import 'package:animooo/core/enums/image_picker_state.dart';
import 'package:animooo/core/enums/view_mode.dart';
import 'package:animooo/core/requests/create_new_category_request.dart';
import 'package:animooo/core/requests/update_category_request.dart';
import 'package:animooo/core/utils/image_picker_utils.dart';
import 'package:animooo/core/widgets/app_dialogs.dart';
import 'package:animooo/core/widgets/app_snackbar.dart';
import 'package:animooo/core/widgets/bottom_sheets.dart';
import 'package:animooo/models/category_model.dart';
import 'package:animooo/services/category_service.dart';
import 'package:flutter/material.dart';

/// Handles all category-related logic and state management
class CategoryController {
  CategoryController() {
    onNavigateHome = services<MainViewController>().goToHome;
    // Prepare for add when first created
    prepareForAdd();
  }

  /// Callback to navigate back to home
  late final VoidCallback onNavigateHome;

  // ============================================================================
  // SERVICES
  // ============================================================================

  final CategoryService _categoryService = services<CategoryService>();

  // ============================================================================
  // STATE
  // ============================================================================

  ViewMode _viewMode = ViewMode.addNew;
  CategoryModel? _categoryToEdit;
  List<CategoryModel> _categories = [];

  // ============================================================================
  // FORM & TEXT CONTROLLERS
  // ============================================================================

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // ============================================================================
  // IMAGE STATE
  // ============================================================================

  final StreamController<(ImagePickerState state, File? imageFile)>
  _imageStreamController =
      StreamController<(ImagePickerState, File?)>.broadcast();

  Stream<(ImagePickerState state, File? imageFile)> get imageStream =>
      _imageStreamController.stream;

  ImagePickerState _imageState = ImagePickerState.none;
  File? _imageFile;
  String? _networkImageUrl;
  bool _isImageChanged = false;

  // ============================================================================
  // LOADING STREAMS
  // ============================================================================

  final StreamController<bool> _isLoadingStreamController =
      StreamController<bool>.broadcast();

  final StreamController<bool> _isAddButtonLoadingStreamController =
      StreamController<bool>.broadcast();

  final StreamController<bool> _isDeleteButtonLoadingStreamController =
      StreamController<bool>.broadcast();

  final StreamController<bool> _isDeleteButtonVisibleStreamController =
      StreamController<bool>.broadcast();

  Stream<bool> get isLoadingStream => _isLoadingStreamController.stream;
  Stream<bool> get isAddButtonLoadingStream =>
      _isAddButtonLoadingStreamController.stream;
  Stream<bool> get isDeleteButtonLoadingStream =>
      _isDeleteButtonLoadingStreamController.stream;
  Stream<bool> get isDeleteButtonVisibleStream =>
      _isDeleteButtonVisibleStreamController.stream;

  bool _isAddButtonLoading = false;
  bool _isDeleteButtonLoading = false;

  // ============================================================================
  // DATA STREAMS
  // ============================================================================

  final StreamController<List<CategoryModel>> _categoriesStreamController =
      StreamController<List<CategoryModel>>.broadcast();

  final StreamController<String> _buttonTextStreamController =
      StreamController<String>.broadcast();

  Stream<List<CategoryModel>> get categoriesStream =>
      _categoriesStreamController.stream;

  Stream<String> get buttonTextStream => _buttonTextStreamController.stream;

  // ============================================================================
  // IMAGE PICKING
  // ============================================================================

  /// Opens bottom sheet to pick image from camera or gallery
  Future<void> onTakeImagePressed(BuildContext context) async {
    BottomSheets.showTakeImageBottomSheet(
      context,
      onTakeFromCameraPressed: () async {
        final file = await ImagePickerUtils.takeImageCamera();
        _handlePickedImage(file);
      },
      onTakeFromGalleryPressed: () async {
        final file = await ImagePickerUtils.takeImageGallery();
        _handlePickedImage(file);
      },
    );
  }

  void _handlePickedImage(File? file) {
    if (file == null) return;

    _imageFile = file;
    _imageState = ImagePickerState.picked;
    _isImageChanged = true;
    _networkImageUrl = null;
    _imageStreamController.add((_imageState, file));
  }

  /// Returns image data for UI display (isNetwork, imageData)
  (bool, dynamic) getImageData() {
    if (_imageFile != null) {
      return (false, _imageFile);
    } else if (_networkImageUrl != null) {
      return (true, _networkImageUrl);
    }
    return (false, null);
  }

  // ============================================================================
  // VALIDATION
  // ============================================================================

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Category name is required";
    }
    if (value.trim().length < 3) {
      return "Category name must be at least 3 characters";
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Category description is required";
    }
    if (value.trim().length < 10) {
      return "Description must be at least 10 characters";
    }
    return null;
  }

  // ============================================================================
  // CATEGORY OPERATIONS
  // ============================================================================

  /// Fetches all categories from server
  Future<void> getAllCategories(BuildContext context) async {
    _isLoadingStreamController.add(true);

    final res = await _categoryService.getAllCategories();

    _isLoadingStreamController.add(false);

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

  /// Handles add or edit based on current mode
  Future<void> onAddEditPressed(BuildContext context) async {
    if (_viewMode == ViewMode.addNew) {
      await _addNewCategory(context);
    } else {
      await _editCategory(context);
    }
  }

  /// Adds a new category
  Future<void> _addNewCategory(BuildContext context) async {
    if (_isAddButtonLoading) return;
    if (!formKey.currentState!.validate()) return;

    // Image is required for new category
    if (_imageState == ImagePickerState.none || _imageFile == null) {
      _imageState = ImagePickerState.error;
      _imageStreamController.add((ImagePickerState.error, null));
      return;
    }

    _isAddButtonLoading = true;
    _isAddButtonLoadingStreamController.add(true);

    final res = await _categoryService.registerNewCategory(
      createCategoryRequest: CreateNewCategoryRequest(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        image: _imageFile!.path,
      ),
    );

    _isAddButtonLoading = false;
    _isAddButtonLoadingStreamController.add(false);

    if (res.isSuccess) {
      // Update list
      _categories.insert(0, res.data!);
      _categoriesStreamController.add(_categories);

      // Show success
      if (context.mounted) {
        AppSnackBar.showSuccess(
          context,
          message: res.alert ?? "Category added successfully",
        );
      }

      // Reset and go home
      resetForm();
      onNavigateHome();
    } else {
      String message =
          res.error?.errors?.join('\n') ??
          res.error?.message ??
          "Error adding category";
      if (context.mounted) {
        AppSnackBar.showError(context, message: message);
      }
    }
  }

  /// Updates an existing category
  Future<void> _editCategory(BuildContext context) async {
    if (_isAddButtonLoading) return;
    if (!formKey.currentState!.validate()) return;
    if (_categoryToEdit == null) return;

    if (_imageState == ImagePickerState.error) {
      _imageStreamController.add((ImagePickerState.error, null));
      return;
    }

    _isAddButtonLoading = true;
    _isAddButtonLoadingStreamController.add(true);

    String? imagePath;
    if (_isImageChanged && _imageFile != null) {
      imagePath = _imageFile!.path;
    }

    final res = await _categoryService.updateCategory(
      updateCategoryRequest: UpdateCategoryRequest(
        id: _categoryToEdit!.id,
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        image: imagePath,
      ),
    );

    _isAddButtonLoading = false;
    _isAddButtonLoadingStreamController.add(false);

    if (res.isSuccess) {
      // Update list
      final index = _categories.indexWhere(
        (cat) => cat.id == _categoryToEdit!.id,
      );
      if (index != -1) {
        _categories[index] = res.data!;
        _categoriesStreamController.add(_categories);
      }

      // Show success
      if (context.mounted) {
        AppSnackBar.showSuccess(
          context,
          message: res.alert ?? "Category updated successfully",
        );
      }

      // Reset and go home
      resetForm();
      onNavigateHome();
    } else {
      String message =
          res.error?.errors?.join('\n') ??
          res.error?.message ??
          "Error updating category";
      if (context.mounted) {
        AppSnackBar.showError(context, message: message);
      }
    }
  }

  /// Deletes the current category being edited
  Future<void> onDeletePressed(BuildContext context) async {
    if (_categoryToEdit == null) return;
    if (_isDeleteButtonLoading) return;

    final bool? confirmed = await AppDialogs.showDeleteDialog(context);
    if (confirmed != true) return;

    _isDeleteButtonLoading = true;
    _isDeleteButtonLoadingStreamController.add(true);

    final res = await _categoryService.deleteCategory(id: _categoryToEdit!.id);

    _isDeleteButtonLoading = false;
    _isDeleteButtonLoadingStreamController.add(false);

    if (res.isSuccess) {
      // Remove from list
      _categories.removeWhere((cat) => cat.id == _categoryToEdit!.id);
      _categoriesStreamController.add(_categories);

      // Show success
      if (context.mounted) {
        AppSnackBar.showSuccess(
          context,
          message: res.alert ?? "Category deleted successfully",
        );
      }

      // Reset and go home
      resetForm();
      onNavigateHome();
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

  /// Called when a category item is tapped for editing
  void onCategoryItemTapped(CategoryModel category) {
    _viewMode = ViewMode.edit;
    _categoryToEdit = category;
    _fillFormData(category);
    _buttonTextStreamController.add("Edit Category");
    _isDeleteButtonVisibleStreamController.add(true);
    services<MainViewController>().goToAddCategory();
  }

  /// Fills form with category data for editing
  void _fillFormData(CategoryModel category) {
    nameController.text = category.name;
    descriptionController.text = category.description;

    _networkImageUrl = category.imagePath;
    _imageFile = File(category.imagePath);
    _imageState = ImagePickerState.picked;
    _isImageChanged = false;

    _imageStreamController.add((_imageState, _imageFile));
  }

  /// Prepares form for adding new category
  void prepareForAdd() {
    resetForm();
    _viewMode = ViewMode.addNew;
    _buttonTextStreamController.add("Add New Category");
    _isDeleteButtonVisibleStreamController.add(false);
  }

  /// Resets form to initial state
  void resetForm() {
    print("resetForm called nameController.text: ${nameController.text} .");
    nameController.clear();
    descriptionController.clear();
    print("resetForm called nameController.text: ${nameController.text} .");

    _imageFile = null;
    _networkImageUrl = null;
    _imageState = ImagePickerState.none;
    _isImageChanged = false;
    _categoryToEdit = null;
    _viewMode = ViewMode.addNew;

    _imageStreamController.add((ImagePickerState.none, null));
    _buttonTextStreamController.add("Add New Category");
    _isDeleteButtonVisibleStreamController.add(false);

    formKey.currentState?.reset();
  }

  // ============================================================================
  // DISPOSAL
  // ============================================================================

  void dispose() {
    _imageStreamController.close();
    _isLoadingStreamController.close();
    _isAddButtonLoadingStreamController.close();
    _isDeleteButtonLoadingStreamController.close();
    _isDeleteButtonVisibleStreamController.close();
    _categoriesStreamController.close();
    _buttonTextStreamController.close();

    nameController.dispose();
    descriptionController.dispose();
    print("CategoryController disposed");
  }
}
