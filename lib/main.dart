import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_bin_sense/colors.dart';
import 'package:smart_bin_sense/views/home_screen.dart';
import 'package:smart_bin_sense/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBxvxeQaz9duSs-855uqI4hKAJl7DCe7xk",
          appId: "1:677800212738:android:ea590ee9dbf3d678666a1b",
          messagingSenderId: "677800212738",
          projectId: "smartbinsense-caa15"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: primary, useMaterial3: false),
      home: user != null ? const HomeScreen() : const SplashScreen(),
    );
  }
}
