import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_fonts.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/resources/app_strings.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ForgetPasswordAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ForgetPasswordAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leadingWidth: AppWidth.w12,
      foregroundColor: Colors.white,
      title: CustomText(
        text: AppStrings.back,
        fontFamily: AppFonts.otamaEp,
        fontWeight: FontWeight.bold,
        fontSize: AppFontSize.f20,
        color: AppColors.primary,
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: AppColors.primary,
          size: AppFontSize.f20,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
