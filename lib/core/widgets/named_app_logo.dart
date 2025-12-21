import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/resources/app_strings.dart';
import 'package:animooo/core/widgets/app_logo.dart';
import 'package:animooo/core/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';

class NamedAppLogo extends StatelessWidget {
  const NamedAppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppLogo(),
        SizedBox(height: AppHeight.h10),
        CustomText(
          text: AppStrings.appName,
          fontSize: AppFontSize.f12,
          color: AppColors.primary,
        ),
      ],
    );
  }
}
