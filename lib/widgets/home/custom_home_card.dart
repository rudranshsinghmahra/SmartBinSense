import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_bin_sense/colors.dart';

Widget customHomeCard(
    {required String image,
    required String title,
    required VoidCallback voidCallback}) {
  return GestureDetector(
    onTap: voidCallback,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      shadowColor: primary.shade600,
      child: Column(
        children: [
          SizedBox(height: 120, width: 120, child: Image.asset(image)),
          Text(
            title,
            style: GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    ),
  );
}
