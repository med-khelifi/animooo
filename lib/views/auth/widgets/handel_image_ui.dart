import 'dart:io';
import 'package:animooo/core/enums/image_picker_state.dart';
import 'package:animooo/views/auth/widgets/select_image_box.dart';
import 'package:animooo/views/auth/widgets/show_image_box.dart';
import 'package:flutter/material.dart';

class HandelImageUi extends StatelessWidget {
  const HandelImageUi({
    super.key,
    required this.imageState,
    this.file,
    this.onTap,
  });
  final ImagePickerState imageState;
  final File? file;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return imageState == ImagePickerState.picked
        ? ShowImageBox(file: file!, onTap: onTap)
        : SelectImageBox(
            onTap: onTap,
            isError: imageState == ImagePickerState.error,
          );
  }
}
