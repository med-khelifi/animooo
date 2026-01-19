import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/views/main/widgets/gategory_list_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppPadding.ph20),
      child: SizedBox(
        height: AppHeight.h90,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => CategoryListItem(),
          separatorBuilder: (context, index) => Gap(AppWidth.w20),
          itemCount: 21,
        ),
      ),
    );
  }
}
