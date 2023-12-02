import 'package:flutter/material.dart';
import 'package:smart_bin_sense/colors.dart';
import 'package:smart_bin_sense/views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: primary,useMaterial3: false),
      home: const SplashScreen(),
    );
  }
}
