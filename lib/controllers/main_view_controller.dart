import 'dart:async';
import 'dart:io';

import 'package:animooo/core/di/injection.dart';
import 'package:animooo/core/enums/image_picker_state.dart';
import 'package:animooo/core/enums/view_mode.dart';
import 'package:animooo/core/requests/create_new_category_request.dart';
import 'package:animooo/core/requests/update_category_request.dart';
import 'package:animooo/core/utils/image_picker_utils.dart';
import 'package:animooo/core/widgets/app_snackbar.dart';
import 'package:animooo/core/widgets/bottom_sheets.dart';
import 'package:animooo/models/category_model.dart';
import 'package:animooo/services/category_service.dart';
import 'package:flutter/cupertino.dart';

enum ImageTarget { category, animal }

class MainViewController {
  MainViewController() {
    _categoryTabButtonTextStreamBuilder.add("Add New Category");
  }
  var _categoryTabViewMode = ViewMode.addNew;

  // ============= Navigation =============

  final StreamController<int> _currentIndexController =
      StreamController<int>.broadcast();
  final GlobalKey<NavigatorState> homeNavigationKey =
      GlobalKey<NavigatorState>();

  Stream<int> get currentIndexStream => _currentIndexController.stream;

  // ============= Forms =============

  final GlobalKey<FormState> categoryFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> animalFormKey = GlobalKey<FormState>();

  // ============= Text Controllers =============

  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController categoryDescriptionController =
      TextEditingController();
  final TextEditingController animalNameController = TextEditingController();
  final TextEditingController animalDescriptionController =
      TextEditingController();
  final TextEditingController animalPriceController = TextEditingController();
  final TextEditingController animalCategoryController =
      TextEditingController();

  // ============= Image Streams =============

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

  CategoryModel? _categoryToEdit;
  bool _isCategoryImageChanged = false; // Track if image was changed

  // ============= Button Loading Streams =============
  final StreamController<String> _categoryTabButtonTextStreamBuilder =
      StreamController<String>.broadcast();
  Stream<String> get categoryTabButtonTextStream =>
      _categoryTabButtonTextStreamBuilder.stream;

  // ============= Button text Streams =============

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

  // ============= Categories Stream =============

  final StreamController<List<CategoryModel>> _categoriesStreamController =
      StreamController<List<CategoryModel>>.broadcast();

  Stream<List<CategoryModel>> get categoriesStream =>
      _categoriesStreamController.stream;

  List<CategoryModel> _categories = [];

  final StreamController<bool> _isLoadingCategoriesStreamController =
      StreamController<bool>.broadcast();

  Stream<bool> get isLoadingCategoriesStream =>
      _isLoadingCategoriesStreamController.stream;

  // ============= Navigation Methods =============

  void onChangeIndex(int index) {
    _currentIndexController.add(index);
  }

  void goBackToHome() {
    _resetCategoryTab();
    _categoryTabViewMode = ViewMode.addNew;
    _categoryTabButtonTextStreamBuilder.add("Add New Category");
    onChangeIndex(0);
  }

  void goToAddCategory() {
    onChangeIndex(2);
  }

  void goToAddAnimal() {
    onChangeIndex(3);
  }

  // ============= Image Picking =============

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
      _isCategoryImageChanged = true; // Mark image as changed
      categoryImageStreamController.add((_categoryImageState, file));
    } else {
      _animalImageFile = file;
      _animalImageState = ImagePickerState.picked;
      animalImageStreamController.add((_animalImageState, file));
    }
  }

  // ============= Validation =============

  String? validateCategoryName(String? value) {
    if (value == null || value.isEmpty) {
      return "Category name is required";
    }
    return null;
  }

  String? validateCategoryDescription(String? value) {
    if (value == null || value.isEmpty) {
      return "Category description is required";
    }
    return null;
  }

  String? validateAnimalPrice(String? value) {
    if (value == null || value.isEmpty) return "Price is required";
    if (double.tryParse(value) == null) return "Invalid price";
    return null;
  }

  // ============= Category Operations =============

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
    if (_categoryImageState == ImagePickerState.none) {
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
      String? message = res.error?.errors?.join('\n') ?? res.error?.message;
      if (context.mounted) {
        AppSnackBar.showError(
          context,
          message: message ?? "Error adding category",
        );
      }
    }
  }

  Future<void> editCategory(BuildContext context) async {
    if (_isAddCategoryButtonLoading) return;
    if (!categoryFormKey.currentState!.validate()) return;

    // For edit mode, image is optional (only validate if user tried to change it)
    // If image state is picked, we have a valid image (either new or existing)
    // If image state is none in edit mode, that means the existing image should be kept
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
      String? message = res.error?.errors?.join('\n') ?? res.error?.message;
      if (context.mounted) {
        AppSnackBar.showError(
          context,
          message: message ?? "Error updating category",
        );
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

  // ============= Animal Operations =============

  void onAddAnimalPressed() {
    if (!animalFormKey.currentState!.validate()) return;
    // TODO: Implement animal addition logic
  }

  // ============= Disposal =============

  void dispose() {
    // Close streams
    _currentIndexController.close();
    categoryImageStreamController.close();
    animalImageStreamController.close();
    _isAddCategoryButtonLoadingStreamController.close();
    _isAddAnimalButtonLoadingStreamController.close();
    _categoriesStreamController.close();
    _isLoadingCategoriesStreamController.close();
    _categoryTabButtonTextStreamBuilder.close();

    // Dispose controllers
    categoryNameController.dispose();
    categoryDescriptionController.dispose();
    animalNameController.dispose();
    animalDescriptionController.dispose();
    animalPriceController.dispose();
    animalCategoryController.dispose();
  }

  /// Fills the category form with existing category data for editing
  void fillCategoryData(CategoryModel categoryModel) {
    categoryNameController.text = categoryModel.name;
    categoryDescriptionController.text = categoryModel.description;

    // Set the image file from network URL
    _categoryImageFile = File(categoryModel.imagePath);
    _categoryImageState = ImagePickerState.picked;
    _isCategoryImageChanged = false; // Image not changed yet, just loaded

    categoryImageStreamController.add((
      _categoryImageState,
      _categoryImageFile,
    ));
  }

  /// Called when a category item is tapped for editing
  void onCategoryItemTaped(CategoryModel categoryModel) {
    _categoryTabViewMode = ViewMode.edit;
    _categoryTabButtonTextStreamBuilder.add("Edit Category");
    _categoryToEdit = categoryModel;
    fillCategoryData(categoryModel);
    goToAddCategory();
  }

  /// Resets the category form to initial state
  void _resetCategoryTab() {
    categoryNameController.clear();
    categoryDescriptionController.clear();
    _categoryImageFile = null;
    _categoryImageState = ImagePickerState.none;
    _isCategoryImageChanged = false;
    _categoryToEdit = null;
    categoryImageStreamController.add((_categoryImageState, null));
  }
}
