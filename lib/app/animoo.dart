import 'package:animooo/core/resources/app_routes.dart';
import 'package:animooo/core/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Animoo extends StatelessWidget {
  const Animoo({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: MaterialApp(
        scaffoldMessengerKey: AppSnackBar.messengerKey,
        initialRoute: RoutesNames.splash,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          splashColor: Colors.transparent,
        ),
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
