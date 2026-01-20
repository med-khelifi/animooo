import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AnimalsList extends StatelessWidget {
  const AnimalsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.pw10),
      sliver: SliverList.separated(
        itemBuilder: (context, index) => AnimalListItem(),
        separatorBuilder: (context, index) => Gap(AppHeight.h10),
        itemCount: 6,
      ),
    );
  }
}

class AnimalListItem extends StatelessWidget {
  const AnimalListItem({super.key});
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
        children: [
          _header(),
          Gap(AppHeight.h6),
          Image.network(
            "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1280px-Image_created_with_a_mobile_phone.png",
          ),
          Gap(AppHeight.h6),
          CustomText(
            text:
                "hi my name is mohammed,I found this sweet dog and am looking for a loving home for them. If you're ready to welcome a new furry friend into your life, this adorable pup is waiting to bring joy and...",
            color: AppColors.blackColor,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _header() => Row(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: "Dog Name",
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
        text: "100\$",
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
