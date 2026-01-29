import 'package:animooo/controllers/main_view_controller.dart';
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

class AnimalView extends StatefulWidget {
  const AnimalView({super.key});

  @override
  State<AnimalView> createState() => _AnimalViewState();
}

class _AnimalViewState extends State<AnimalView> {
  late MainViewController _mainViewController;
  @override
  void initState() {
    super.initState();
    _mainViewController = services<MainViewController>();
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
          key: _mainViewController.animalFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Add New Animal",
                color: AppColors.primary,
                fontSize: AppFontSize.f24,
                fontFamily: AppFonts.otamaEp,
              ),
              Gap(AppHeight.h13),
              CategoryUserInfo(),
              Gap(AppHeight.h13),
              CustomTextFormField(
                hint: "Enter Animal Name",
                label: "Animal Name",
                controller: _mainViewController.animalNameController,
                validator: _mainViewController.validateCategoryName,
              ),
              Gap(AppHeight.h6),
              CustomTextFormField(
                hint: "Enter Animal description",
                label: "Animal description",
                controller: _mainViewController.animalDescriptionController,
                validator: _mainViewController.validateCategoryDescription,
                maxLines: 3,
              ),
              Gap(AppHeight.h13),
              CustomText(
                text: "Upload Image For Your Animal",
                color: AppColors.secondary,
                fontSize: AppFontSize.f14,
                fontFamily: AppFonts.poppins,
              ),
              Gap(AppHeight.h6),
              StreamBuilder(
                stream: _mainViewController.animalImageStream,
                builder: (context, asyncSnapshot) {
                  return HandelImageUi(
                    imageState: asyncSnapshot.data?.$1 ?? ImagePickerState.none,
                    file: asyncSnapshot.data?.$2,
                    onTap: () => _mainViewController.onTakeImagePressed(
                      context,
                      ImageTarget.animal,
                    ),
                  );
                },
              ),
              Gap(AppHeight.h30),
              CustomTextFormField(
                hint: "Animal Price",
                label: "Animal Category",
                controller: _mainViewController.animalPriceController,
                validator: _mainViewController.validateCategoryName,
              ),
              Gap(AppHeight.h6),
              CustomTextFormField(
                hint: "Enter Category Name",
                label: "Animal Name",
                controller: _mainViewController.animalCategoryController,
                validator: _mainViewController.validateCategoryName,
              ),
              Gap(AppHeight.h16),
              CustomButton(
                text: "Add Animal",
                onPressed: _mainViewController.goToAddAnimal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
