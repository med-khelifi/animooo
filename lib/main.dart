import 'package:animooo/app/animoo.dart';
import 'package:animooo/core/di/injection.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupInjection();
  runApp(const Animoo());
}

