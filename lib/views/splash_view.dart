import 'package:animooo/core/di/injection.dart';
import 'package:animooo/core/resources/app_colors.dart';
import 'package:animooo/core/resources/app_navigation.dart';
import 'package:animooo/core/resources/app_routes.dart';
import 'package:animooo/core/resources/app_sizes.dart';
import 'package:animooo/core/storge/storge_helper.dart';
import 'package:animooo/core/utils/internet_connection_utils.dart';
import 'package:animooo/core/widgets/app_snackbar.dart';
import 'package:animooo/core/widgets/named_app_logo.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _checkInternet();

    // Optional: splash delay (nice UX)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    await _navigateToLogin();
  }

  Future<void> _checkInternet() async {
    _hasInternet = await InternetConnectionUtils.instance.hasInternet();

    InternetConnectionUtils.instance.listen(
      onConnected: () {
        if (!_hasInternet && mounted) {
          AppSnackBar.showInternetBack(context);
          _hasInternet = true;
        }
      },
      onDisconnected: () {
        if (_hasInternet && mounted) {
          AppSnackBar.showNoInternet(context);
          _hasInternet = false;
        }
      },
    );
  }

  Future<void> _navigateToLogin() async {
    final storage = services<StorageHelper>();
    final token = await storage.getAccessToken();

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      AppNavigation.pushAndRemoveUntil(RoutesNames.main);
    } else {
      AppNavigation.pushAndRemoveUntil(RoutesNames.login);
    }
  }

  @override
  void dispose() {
    InternetConnectionUtils.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NamedAppLogo(),
            Gap(AppHeight.h150),
            LoadingAnimationWidget.staggeredDotsWave(
              color: AppColors.primary,
              size: AppFontSize.f24,
            ),
          ],
        ),
      ),
    );
  }
}
