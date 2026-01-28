import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:animooo/models/animal_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AnimalsList extends StatelessWidget {
  const AnimalsList({super.key, required this.animals});
  final List<AnimalModel> animals;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.pw10),
      sliver: SliverList.separated(
        itemBuilder: (context, index) => AnimalListItem(animal: animals[index]),
        separatorBuilder: (context, index) => Gap(AppHeight.h10),
        itemCount: animals.length,
      ),
    );
  }
}

class AnimalListItem extends StatelessWidget {
  const AnimalListItem({super.key, required this.animal});
  final AnimalModel animal;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.pw8,
        vertical: AppPadding.ph8,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(AppRadius.r10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(animal.animalName, animal.animalPrice),
          Gap(AppHeight.h6),
          Image.network(animal.animalImage),
          Gap(AppHeight.h6),
          CustomText(
            text: animal.animalDescription,
            color: AppColors.blackColor,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _header(name, price) => Row(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: name,
            fontSize: AppFontSize.f12,
            color: AppColors.blackColor,
            fontFamily: AppFonts.poppins,
          ),
          CustomText(
            text: "Created by Admin",
            fontSize: AppFontSize.f12,
            color: AppColors.greyColor,
            fontFamily: AppFonts.poppins,
          ),
        ],
      ),
      Spacer(),
      CustomText(
        text: "$price\$",
        fontSize: AppFontSize.f12,
        color: AppColors.primary,
        fontFamily: AppFonts.poppins,
      ),
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.more_vert, color: AppColors.blackColor),
      ),
    ],
  );
}
