import 'package:animooo/controllers/main_view_controller.dart';
import 'package:animooo/core/di/injection.dart';
import 'package:animooo/core/enums/image_picker_state.dart';
import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/widgets/custom_button.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:animooo/core/widgets/custom_text_form_field.dart';
import 'package:animooo/models/category_model.dart';
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
  late MainViewController _mainViewController;
  @override
  void initState() {
    super.initState();
    _mainViewController = services<MainViewController>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final CategoryModel? categoryModel =
        ModalRoute.of(context)!.settings.arguments as CategoryModel?;
    if (categoryModel != null) {
      _mainViewController.fillCategoryData(categoryModel);
    }
  }

  @override
  void dispose() {
    _mainViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.pw18),
        child: Form(
          key: _mainViewController.categoryFormKey,
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
                controller: _mainViewController.categoryNameController,
                validator: _mainViewController.validateCategoryName,
              ),
              Gap(AppHeight.h6),
              CustomTextFormField(
                hint: "Enter Category description",
                label: "Category description",
                controller: _mainViewController.categoryDescriptionController,
                validator: _mainViewController.validateCategoryDescription,
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
                stream: _mainViewController.categoryImageStream,
                builder: (context, asyncSnapshot) {
                  return HandelImageUi(
                    imageState: asyncSnapshot.data?.$1 ?? ImagePickerState.none,
                    file: asyncSnapshot.data?.$2,
                    onTap: () => _mainViewController.onTakeImagePressed(
                      context,
                      ImageTarget.category,
                    ),
                  );
                },
              ),
              Gap(AppHeight.h30),
              StreamBuilder(
                stream: _mainViewController.isAddCategoryButtonEnabledStream,
                builder: (context, asyncSnapshot) {
                  return StreamBuilder(
                    stream: _mainViewController.categoryTabButtonTextStream,
                    builder: (context, asyncSnapshot1) {
                      return Align(
                        alignment: Alignment.center,
                        child: CustomButton(
                          text: asyncSnapshot1.data ?? "Add New Category",
                          onPressed: () => _mainViewController
                              .onAddEditCategoryPressed(context),
                          isLoading: asyncSnapshot.data ?? false,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
