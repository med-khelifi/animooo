import 'package:animooo/core/resources/app_assets.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppAssets.logoSVG,
      height: AppHeight.h70,
      width: AppWidth.w72,
    );
  }
}
