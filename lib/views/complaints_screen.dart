import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_bin_sense/widgets/appbar/customAppbarOnlyTitle.dart';

import '../widgets/complaints/customComplaintCard.dart';
import '../widgets/complaints/customLatestComplaintCard.dart';
import 'file_complaint_screen.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: customAppbarOnlyTitle("Complaints", context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customComplaintCard("File a complaint", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FileComplaintScreen(),
                ),
              );
            }, false),
            customComplaintCard("Previous complaint", () {}, true),
            Padding(
              padding: const EdgeInsets.only(top: 38.0, left: 6, right: 6),
              child: Text(
                "Latest complaints near you",
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            SizedBox(
              height: 220,
              width: double.infinity,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  customLatestComplaintCard("assets/images/garbage_litter.jpeg",
                      "Garbage vehicle not arrived"),
                  customLatestComplaintCard("assets/images/garbage_litter.jpeg",
                      "Garbage vehicle not arrived"),
                  customLatestComplaintCard("assets/images/garbage_litter.jpeg",
                      "Garbage vehicle not arrived"),
                  customLatestComplaintCard("assets/images/garbage_litter.jpeg",
                      "Garbage vehicle not arrived"),
                  customLatestComplaintCard("assets/images/garbage_litter.jpeg",
                      "Garbage vehicle not arrived"),
                  customLatestComplaintCard("assets/images/garbage_litter.jpeg",
                      "Garbage vehicle not arrived"),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
