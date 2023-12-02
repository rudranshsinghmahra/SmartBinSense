import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../colors.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  TextEditingController otpEditingController = TextEditingController();
  String currentText = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "A 6 digit OTP has been sent\n to your mobile number",
              style: GoogleFonts.nunito(),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 35.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Enter ",
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  Text(
                    "OTP",
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: primary.shade600),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: PinCodeTextField(
                appContext: context,
                pastedTextStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                length: 6,
                obscureText: true,
                obscuringCharacter: '*',
                blinkWhenObscuring: true,
                enablePinAutofill: true,
                hintCharacter: "X",
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  inactiveColor: Colors.grey,
                  selectedColor: primary.shade600,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 50,
                  fieldWidth: 50,
                  activeFillColor: Colors.white,
                ),
                cursorColor: Colors.black,
                animationDuration: const Duration(milliseconds: 300),
                controller: otpEditingController,
                keyboardType: TextInputType.number,
                onCompleted: (v) {
                  debugPrint("Completed");
                },
                onChanged: (value) {
                  debugPrint(value);
                  setState(() {
                    currentText = value;
                  });
                },
                beforeTextPaste: (text) {
                  debugPrint("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
