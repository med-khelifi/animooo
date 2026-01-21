import 'dart:async';
import 'dart:io';

import 'package:animooo/core/enums/image_picker_state.dart';
import 'package:animooo/core/utils/image_picker_utils.dart';
import 'package:animooo/core/widgets/bottom_sheets.dart';
import 'package:flutter/cupertino.dart';

class MainViewController {
  late StreamController<int> _currentIndexController;
  late StreamController<(ImagePickerState state, File? imageFile)>
  imageStreamController;
  late File? _userImageFile;
  late ImagePickerState _userImageState;
  Stream<int> get currentIndexStream => _currentIndexController.stream;
  Stream<(ImagePickerState state, File? imageFile)> get imageStream =>
      imageStreamController.stream;

  MainViewController() {
    _currentIndexController = StreamController<int>.broadcast();
    imageStreamController =
        StreamController<(ImagePickerState state, File? imageFile)>.broadcast();
  }

  void onChangeIndex(int index) {
    _currentIndexController.add(index);
  }

  void dispose() {
    _currentIndexController.close();
  }

  void onTakeImagePressed(BuildContext context) async {
    BottomSheets.showTakeImageBottomSheet(
      context,
      onTakeFromCameraPressed: () async {
        _userImageFile = await ImagePickerUtils.takeImageCamera();
        if (_userImageFile != null) {
          _userImageState = ImagePickerState.picked;
          imageStreamController.add((_userImageState, _userImageFile));
        }
      },
      onTakeFromGalleryPressed: () async {
        _userImageFile = await ImagePickerUtils.takeImageGallery();
        if (_userImageFile != null) {
          _userImageState = ImagePickerState.picked;
          imageStreamController.add((_userImageState, _userImageFile));
        }
      },
    );
  }
}
