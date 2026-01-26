import 'dart:async';
import 'dart:io';

import 'package:animooo/core/di/injection.dart';
import 'package:animooo/core/enums/image_picker_state.dart';
import 'package:animooo/core/requests/create_new_category_request.dart';
import 'package:animooo/core/utils/image_picker_utils.dart';
import 'package:animooo/core/widgets/app_snackbar.dart';
import 'package:animooo/core/widgets/bottom_sheets.dart';
import 'package:animooo/models/category_model.dart';
import 'package:animooo/services/category_service.dart';
import 'package:flutter/cupertino.dart';

enum ImageTarget { category, animal }

class MainViewController {
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

  // ============= Button Loading Streams =============

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

  void goBackToHome() {}

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

  void onAddCategoryPressed(BuildContext context) async {
    goBackToHome();

    if (_isAddCategoryButtonLoading) return;
    if (!categoryFormKey.currentState!.validate()) return;

    if (_categoryImageState == ImagePickerState.none) {
      _categoryImageState = ImagePickerState.error;
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
      categoryNameController.clear();
      categoryDescriptionController.clear();
      _categoryImageFile = null;
      _categoryImageState = ImagePickerState.none;
      categoryImageStreamController.add((_categoryImageState, null));

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

    // Dispose controllers
    categoryNameController.dispose();
    categoryDescriptionController.dispose();
    animalNameController.dispose();
    animalDescriptionController.dispose();
    animalPriceController.dispose();
    animalCategoryController.dispose();
  }
}
