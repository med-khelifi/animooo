import 'package:animooo/controllers/category_controller.dart';
import 'package:animooo/core/di/injection.dart';
import 'package:animooo/core/enums/image_picker_state.dart';
import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/widgets/custom_button.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:animooo/core/widgets/custom_text_form_field.dart';
import 'package:animooo/views/auth/widgets/handel_image_ui.dart';
import 'package:animooo/views/main/widgets/category_user_info.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  late CategoryController _categoryController;
  @override
  void initState() {
    super.initState();
    _categoryController = services<CategoryController>();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.pw18),
        child: Form(
          key: _categoryController.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Add New Category",
                color: AppColors.primary,
                fontSize: AppFontSize.f24,
                fontFamily: AppFonts.otamaEp,
              ),
              Gap(AppHeight.h13),
              CategoryUserInfo(),
              Gap(AppHeight.h13),
              CustomTextFormField(
                hint: "Enter Category Name",
                label: "Category Name",
                controller: _categoryController.nameController,
                validator: _categoryController.validateName,
              ),
              Gap(AppHeight.h6),
              CustomTextFormField(
                hint: "Enter Category description",
                label: "Category description",
                controller: _categoryController.descriptionController,
                validator: _categoryController.validateDescription,
                maxLines: 3,
              ),
              Gap(AppHeight.h13),
              CustomText(
                text: "Upload Image For Your Category",
                color: AppColors.secondary,
                fontSize: AppFontSize.f14,
                fontFamily: AppFonts.poppins,
              ),
              Gap(AppHeight.h6),
              StreamBuilder(
                stream: _categoryController.imageStream,
                builder: (context, asyncSnapshot) {
                  return HandelImageUi(
                    imageState: asyncSnapshot.data?.$1 ?? ImagePickerState.none,
                    file: asyncSnapshot.data?.$2,
                    onTap: () =>
                        _categoryController.onTakeImagePressed(context),
                  );
                },
              ),
              Gap(AppHeight.h30),
              StreamBuilder(
                stream: _categoryController.isAddButtonLoadingStream,
                builder: (context, asyncSnapshot) {
                  return StreamBuilder(
                    stream: _categoryController.buttonTextStream,
                    builder: (context, asyncSnapshot1) {
                      return Align(
                        alignment: Alignment.center,
                        child: CustomButton(
                          text: asyncSnapshot1.data ?? "Add New Category",
                          onPressed: () =>
                              _categoryController.onAddEditPressed(context),
                          isLoading: asyncSnapshot.data ?? false,
                        ),
                      );
                    },
                  );
                },
              ),
              Gap(AppHeight.h10),
              StreamBuilder(
                stream: _categoryController.isDeleteButtonVisibleStream,
                builder: (context, snapshot) => snapshot.data ?? false
                    ? SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StreamBuilder(
                              stream: _categoryController
                                  .isDeleteButtonLoadingStream,
                              builder: (context, asyncSnapshot) {
                                return CustomButton(
                                  text: "Delete Category",
                                  color: AppColors.red,
                                  isLoading: asyncSnapshot.data ?? false,
                                  onPressed: () => _categoryController
                                      .onDeletePressed(context),
                                );
                              },
                            ),
                            Gap(AppHeight.h10),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
