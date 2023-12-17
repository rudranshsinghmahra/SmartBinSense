import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_bin_sense/constants.dart';
import 'package:smart_bin_sense/services/firebase_services.dart';

FirebaseServices firebaseServices = FirebaseServices();

Widget customHelplineCardOne(String title, IconData icon, String docId) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xfffff1cc),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Icon(
                    icon,
                    size: 22,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  title,
                  style: GoogleFonts.nunito(fontSize: 16),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xfffbb308),
                      borderRadius: BorderRadius.circular(30)),
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Icon(
                      Icons.call,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xfffbb308),
                          borderRadius: BorderRadius.circular(30)),
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(
                          Icons.message,
                          color: Colors.white,
                          size: 20,
                        ),
                      )),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
