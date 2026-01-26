import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/models/category_model.dart';
import 'package:animooo/views/main/widgets/gategory_list_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CategoryList extends StatelessWidget {
  final List<CategoryModel> categories;

  const CategoryList({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: AppHeight.h100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          itemCount: categories.length,
          separatorBuilder: (_, _) => Gap(AppWidth.w12),
          itemBuilder: (context, index) {
            return CategoryListItem(
              key: ValueKey(index),
              categoryModel: categories[index]!,
            );
          },
        ),
      ),
    );
  }
}
