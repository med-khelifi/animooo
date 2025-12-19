import 'package:animooo/core/resources/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Animoo extends StatelessWidget {
  const Animoo({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      child: MaterialApp(
        initialRoute: RoutesNames.login,
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}
