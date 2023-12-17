import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customLatestComplaintCard(String image, String title,String location) {
  return SizedBox(
    height: 220,
    width: 250,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            SizedBox(
                height: 160,
                width: double.infinity,
                child: Image.network(image, fit: BoxFit.fill)),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                title,
                style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 8, bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color(0xffffa506),
                    size: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Text(
                      location,
                      style: GoogleFonts.nunito(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
