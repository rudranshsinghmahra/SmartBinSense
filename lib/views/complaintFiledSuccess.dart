import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_bin_sense/colors.dart';
import 'package:smart_bin_sense/widgets/appbar/customAppbarOnlyTitle.dart';

class ComplaintFiledSuccessScreen extends StatefulWidget {
  const ComplaintFiledSuccessScreen({super.key});

  @override
  State<ComplaintFiledSuccessScreen> createState() =>
      _ComplaintFiledSuccessScreenState();
}

class _ComplaintFiledSuccessScreenState
    extends State<ComplaintFiledSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff5c964a),
      child: SafeArea(
          child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: customAppbarOnlyTitle("Complaints", context),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/filed_success.png"),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Icon(
                Icons.check_circle,
                color: primary.shade700,
                size: 60,
              ),
            ),
            Text("Your complaint has been filed.",style: GoogleFonts.nunito(),),
          ],
        ),
      )),
    );
  }
}
