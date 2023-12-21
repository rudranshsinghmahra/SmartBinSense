import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget truckDriverCustomCard(BuildContext context, String deviceId) {
  return Card(
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: SizedBox(
      width: double.infinity,
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0, bottom: 8),
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 5,
                        color: Colors.white,
                      ),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0.6,
                            offset: Offset(-0.2, 0.2),
                            blurRadius: 3)
                      ]),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16.0,
                    left: 12,
                    right: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Name:',
                              style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Tinku Chacha',
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Reg. ID:',
                                style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.bold)),
                            Text(
                              'Truck Driver',
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Device. ID:',
                              style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.bold)),
                          Text(
                            deviceId,
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.phone),
              const SizedBox(width: 10),
              Text('+1234567890',
                  style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.location_on),
              const SizedBox(width: 10),
              Text('Punjab, India',
                  style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    ),
  );
}
