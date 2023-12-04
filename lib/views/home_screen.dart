import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_bin_sense/colors.dart';
import 'package:smart_bin_sense/widgets/home_card/custom_home_card.dart';

import '../widgets/appbar/custom_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150),
          child: customAppBar(searchTextEditingController),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Home",
                    style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: primary.shade600,
                        size: 32,
                      ),
                      Text(
                        "Click & Complaint",
                        style: GoogleFonts.roboto(
                            fontSize: 10, fontWeight: FontWeight.w600),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, crossAxisSpacing: 10),
                  children: [
                    customHomeCard(
                      image: "assets/images/track_truck.png",
                      title: "Track Garbage Truck",
                    ),
                    customHomeCard(
                      image: "assets/images/complaints.png",
                      title: "Complaints",
                    ),
                    customHomeCard(
                      image: "assets/images/bins_around.png",
                      title: "Bins around you",
                    ),
                    customHomeCard(
                      image: "assets/images/schedule.png",
                      title: "Collection Schedule",
                    ),
                    customHomeCard(
                      image: "assets/images/events_reminder.png",
                      title: "Events and Reminders",
                    ),
                    customHomeCard(
                      image: "assets/images/helpline.png",
                      title: "Helpline",
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
