import 'dart:io';
import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class ShowImageBox extends StatelessWidget {
  const ShowImageBox({super.key, this.onTap, required this.file});
  final void Function()? onTap;
  final File file;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          color: AppColors.primary,
          dashPattern: [5, 5],
          radius: Radius.circular(AppRadius.r10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.r10)),
          child: Image.file(file),
        ),
      ),
    );
  }
}
