import 'package:animooo/core/resources/app_routes.dart';
import 'package:animooo/core/utils/internet_connection_utils.dart';
import 'package:animooo/core/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Animoo extends StatefulWidget {
  const Animoo({super.key});

  @override
  State<Animoo> createState() => _AnimooState();
}

class _AnimooState extends State<Animoo> {
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _checkInternet();
  }

  void _checkInternet() async {
    _hasInternet = await InternetConnectionUtils.instance.hasInternet();

    InternetConnectionUtils.instance.listen(
      onConnected: () {
        if (!_hasInternet) {
          AppSnackBar.showInternetBack(context);
          _hasInternet = true;
        }
      },
      onDisconnected: () {
        if (_hasInternet) {
          AppSnackBar.showNoInternet(context);
          _hasInternet = false;
        }
      },
    );
  }

  @override
  void dispose() {
    InternetConnectionUtils.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: MaterialApp(
        scaffoldMessengerKey: AppSnackBar.messengerKey,
        initialRoute: RoutesNames.login,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          splashColor: Colors.transparent,
        ),
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}
