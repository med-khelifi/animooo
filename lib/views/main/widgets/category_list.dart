import 'package:animooo/views/main/widgets/gategory_list_item.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: List.generate(21, (index) => CategoryListItem())),
      ),
    );
  }
}
