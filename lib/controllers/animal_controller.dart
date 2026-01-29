import 'dart:async';
import 'dart:io';

import 'package:animooo/controllers/main_view_controller.dart';
import 'package:animooo/core/di/injection.dart';
import 'package:animooo/core/enums/image_picker_state.dart';
import 'package:animooo/core/utils/image_picker_utils.dart';
import 'package:animooo/core/widgets/app_snackbar.dart';
import 'package:animooo/core/widgets/bottom_sheets.dart';
import 'package:animooo/models/animal_model.dart';
import 'package:animooo/services/animal_service.dart';
import 'package:flutter/material.dart';

/// Handles all animal-related logic and state management
class AnimalController {
  AnimalController() {
    onNavigateHome = services<MainViewController>().goToHome;
  }

  /// Callback to navigate back to home
  late final VoidCallback onNavigateHome;

  // ============================================================================
  // SERVICES
  // ============================================================================

  final AnimalService _animalService = services<AnimalService>();

  // ============================================================================
  // STATE
  // ============================================================================

  List<AnimalModel> _animals = [];

  // ============================================================================
  // FORM & TEXT CONTROLLERS
  // ============================================================================

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

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

  Stream<bool> get isLoadingStream => _isLoadingStreamController.stream;
  Stream<bool> get isAddButtonLoadingStream =>
      _isAddButtonLoadingStreamController.stream;

  bool _isAddButtonLoading = false;

  // ============================================================================
  // DATA STREAMS
  // ============================================================================

  final StreamController<List<AnimalModel>> _animalsStreamController =
      StreamController<List<AnimalModel>>.broadcast();

  Stream<List<AnimalModel>> get animalsStream =>
      _animalsStreamController.stream;

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
      return "Animal name is required";
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Animal description is required";
    }
    return null;
  }

  String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) return "Price is required";
    final price = double.tryParse(value);
    if (price == null) return "Invalid price format";
    if (price <= 0) return "Price must be greater than 0";
    return null;
  }

  String? validateCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Category is required";
    }
    return null;
  }

  // ============================================================================
  // ANIMAL OPERATIONS
  // ============================================================================

  /// Fetches all animals from server
  Future<void> getAllAnimals(BuildContext context) async {
    _isLoadingStreamController.add(true);

    final res = await _animalService.getAllAnimals();

    _isLoadingStreamController.add(false);

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

  /// Adds a new animal
  Future<void> onAddPressed(BuildContext context) async {
    if (_isAddButtonLoading) return;
    if (!formKey.currentState!.validate()) return;

    // TODO: Implement animal addition logic
    if (context.mounted) {
      //AppSnackBar.showInfo(context, message: "Animal feature coming soon!");
    }
  }

  /// Resets form to initial state
  void resetForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    categoryController.clear();

    _imageFile = null;
    _networkImageUrl = null;
    _imageState = ImagePickerState.none;
    _isImageChanged = false;

    _imageStreamController.add((ImagePickerState.none, null));

    formKey.currentState?.reset();
  }

  // ============================================================================
  // DISPOSAL
  // ============================================================================

  void dispose() {
    _imageStreamController.close();
    _isLoadingStreamController.close();
    _isAddButtonLoadingStreamController.close();
    _animalsStreamController.close();

    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    categoryController.dispose();
  }
}
