import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget blogPostCard(
    {required String imageUrl,
    required String title,
    required String description,
    required String postedOn}) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 150,
                  width: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                            description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.nunito(fontSize: 16)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Posted: 06/11/2024",
                              style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}
