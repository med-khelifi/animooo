import 'dart:async';
import 'dart:io';

import 'package:animooo/core/di/injection.dart';
import 'package:animooo/core/enums/image_picker_state.dart';
import 'package:animooo/core/requests/create_new_category_request.dart';
import 'package:animooo/core/utils/image_picker_utils.dart';
import 'package:animooo/core/widgets/app_snackbar.dart';
import 'package:animooo/core/widgets/bottom_sheets.dart';
import 'package:animooo/services/category_service.dart';
import 'package:flutter/cupertino.dart';

enum ImageTarget { category, animal }

class MainViewController {
  // Navigation
  late StreamController<int> _currentIndexController;

  // Forms
  GlobalKey<FormState> categoryFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> animalFormKey = GlobalKey<FormState>();
  GlobalKey<NavigatorState> homeNavigationKey = GlobalKey<NavigatorState>();

  // Image Streams
  late StreamController<(ImagePickerState state, File? imageFile)>
  categoryImageStreamController;
  late StreamController<(ImagePickerState state, File? imageFile)>
  animalImageStreamController;

  // buttons Stream
  late StreamController<bool> _isAddCategoryButtonLoadingStreamControllers;
  late StreamController<bool> _isAddAnimalButtonLoadingStreamControllers;

  // buttons Stream
  Stream<bool> get isAddCategoryButtonEnabledStream =>
      _isAddCategoryButtonLoadingStreamControllers.stream;
  Stream<bool> get isAddAnimalButtonEnabledStream =>
      _isAddAnimalButtonLoadingStreamControllers.stream;
  bool _isAddCategoryButtonLoading = false;
  bool _isAddAnimalButtonLoading = false;
  File? _categoryImageFile;
  File? _animalImageFile;

  ImagePickerState _categoryImageState = ImagePickerState.none;
  ImagePickerState _animalImageState = ImagePickerState.none;

  // Controllers
  late TextEditingController categoryNameController;
  late TextEditingController categoryDescriptionController;

  late TextEditingController animalNameController;
  late TextEditingController animalDescriptionController;
  late TextEditingController animalPriceController;
  late TextEditingController animalCategoryController;

  // Streams
  Stream<int> get currentIndexStream => _currentIndexController.stream;

  Stream<(ImagePickerState state, File? imageFile)> get categoryImageStream =>
      categoryImageStreamController.stream;

  Stream<(ImagePickerState state, File? imageFile)> get animalImageStream =>
      animalImageStreamController.stream;

  MainViewController() {
    _currentIndexController = StreamController<int>.broadcast();

    categoryImageStreamController =
        StreamController<(ImagePickerState, File?)>.broadcast();

    animalImageStreamController =
        StreamController<(ImagePickerState, File?)>.broadcast();
    _isAddCategoryButtonLoadingStreamControllers =
        StreamController<bool>.broadcast();
    _isAddAnimalButtonLoadingStreamControllers =
        StreamController<bool>.broadcast();
    // Init controllers
    categoryNameController = TextEditingController();
    categoryDescriptionController = TextEditingController();

    animalNameController = TextEditingController();
    animalDescriptionController = TextEditingController();
    animalPriceController = TextEditingController();
    animalCategoryController = TextEditingController();
  }

  void onChangeIndex(int index) {
    if (index == 0) {
      goBackToHome();
    }
    _currentIndexController.add(index);
  }

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

  void onAddCategoryPressed(BuildContext context) async {
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
    _isAddCategoryButtonLoadingStreamControllers.add(
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
    _isAddCategoryButtonLoadingStreamControllers.add(
      _isAddCategoryButtonLoading,
    );
    if (res.isSuccess) {
      AppSnackBar.showSuccess(
        context,
        message: res.alert ?? "Something went wrong",
      );
      categoryNameController.clear();
      categoryDescriptionController.clear();
      _categoryImageFile = null;
      _categoryImageState = ImagePickerState.none;
      categoryImageStreamController.add((_categoryImageState, null));
    } else {
      String? message = res.error?.errors?.join('\n') ?? res.error?.message;
      AppSnackBar.showError(context, message: message ?? "error");
    }
  }

  void onAddAnimalPressed() {
    if (!categoryFormKey.currentState!.validate()) return;
  }

  void dispose() {
    _currentIndexController.close();
    categoryImageStreamController.close();
    animalImageStreamController.close();

    categoryNameController.dispose();
    categoryDescriptionController.dispose();

    animalNameController.dispose();
    animalDescriptionController.dispose();
    animalPriceController.dispose();
    animalCategoryController.dispose();
  }

  void goBackToHome() {
    homeNavigationKey.currentState?.popUntil((route) => route.isFirst);
  }

  void goToAddCategory() {
    onChangeIndex(2);
  }

  void goToAddAnimal() {
    onChangeIndex(3);
  }
}
