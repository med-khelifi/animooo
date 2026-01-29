import 'package:animooo/controllers/animal_controller.dart';
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
  late AnimalController _animalController;
  @override
  void initState() {
    super.initState();
    _animalController = services<AnimalController>();
  }

  @override
  void dispose() {
    _animalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.pw18),
        child: Form(
          key: _animalController.formKey,
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
                controller: _animalController.nameController,
                validator: _animalController.validateName,
              ),
              Gap(AppHeight.h6),
              CustomTextFormField(
                hint: "Enter Animal description",
                label: "Animal description",
                controller: _animalController.descriptionController,
                validator: _animalController.validateDescription,
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
                stream: _animalController.imageStream,
                builder: (context, asyncSnapshot) {
                  return HandelImageUi(
                    imageState: asyncSnapshot.data?.$1 ?? ImagePickerState.none,
                    file: asyncSnapshot.data?.$2,
                    onTap: () => _animalController.onTakeImagePressed(context),
                  );
                },
              ),
              Gap(AppHeight.h30),
              CustomTextFormField(
                hint: "Animal Price",
                label: "Animal Price",
                controller: _animalController.priceController,
                validator: _animalController.validatePrice,
              ),
              Gap(AppHeight.h6),
              CustomTextFormField(
                hint: "Enter Category Name",
                label: "Animal Name",
                controller: _animalController.categoryController,
                validator: _animalController.validateCategory,
              ),
              Gap(AppHeight.h16),
              CustomButton(
                text: "Add Animal",
                onPressed: () => _animalController.onAddPressed(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
