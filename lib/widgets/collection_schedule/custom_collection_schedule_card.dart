import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_bin_sense/colors.dart';

Widget customCollectionScheduleCard(
    {required String weekName,
    required Timestamp timeStamp,
    required bool isToday}) {
  DateTime formattedDateTime = timeStamp.toDate();
  return Container(
    decoration: isToday
        ? BoxDecoration(
            color: primary.shade600, borderRadius: BorderRadius.circular(12))
        : const BoxDecoration(),
    child: Padding(
      padding: isToday ? const EdgeInsets.all(18) : const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                weekName,
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isToday ? Colors.white : Colors.black),
              ),
              Text(
                DateFormat('MMMM d', 'en_US').format(formattedDateTime),
                style: GoogleFonts.nunito(
                    color: isToday ? Colors.white : Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          Icon(
            Icons.check_circle,
            color: isToday ? Colors.white : primary.shade600,
          ),
          Column(
            children: [
              const Text(" "),
              Text(
                DateFormat('hh:mm a').format(formattedDateTime),
                style: GoogleFonts.nunito(
                    color: isToday ? Colors.white : Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    ),
  );
}
