import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xff5c964a),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: 230,
              width: 230,
              child: Image.asset('assets/images/smartSenseLogo.png'),
            ),
          ),
          const Text(
            "SmartBinSense",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 29, color: Colors.white),
          ),
          Text(
            "Revolutionizing Waste in Your City",
            style: GoogleFonts.nunito(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white
            )
          ),
        ],
      ),
    ));
  }
}
