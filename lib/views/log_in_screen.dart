import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_bin_sense/colors.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController phoneEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "LOG IN / SIGN UP",
              style: GoogleFonts.nunito(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Enter ",
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold, fontSize: 22),
                ),
                Text(
                  "Mobile Number",
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: primary.shade600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 22.0),
              child: Text(
                "These details are not shared with anyone",
                style: GoogleFonts.nunito(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: phoneEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        hintText: "XXXXXXXXXX",
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: primary.shade600),
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 35.0),
              child: Text(
                "OR",
                style: GoogleFonts.nunito(
                  color: primary.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Card(
                color: Colors.white,
                elevation: 5,
                shadowColor: primary.shade600,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.red,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: Text(
                          "Sign in with Google",
                          style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10),
              child: Card(
                color: Colors.white,
                elevation: 5,
                shadowColor: primary.shade600,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.facebook,
                        color: Color(0xff187ae7),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: Text(
                          "Sign in with Facebook",
                          style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: ElevatedButton(onPressed: (){}, child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Send OTP",style: GoogleFonts.nunito(),),
              )),
            )
          ],
        ),
      ),
    );
  }
}
