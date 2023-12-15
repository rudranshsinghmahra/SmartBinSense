import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_bin_sense/chooseAndTrackTruck.dart';
import 'package:smart_bin_sense/colors.dart';
import 'package:smart_bin_sense/services/firebase_services.dart';
import 'package:smart_bin_sense/views/bins_around_you.dart';
import 'package:smart_bin_sense/views/collection_schedule_screen.dart';
import 'package:smart_bin_sense/views/complaints_screen.dart';
import 'package:smart_bin_sense/views/helpline_screen.dart';

import '../widgets/appbar/custom_appbar_location.dart';
import '../widgets/home/custom_home_card.dart';
import '../widgets/profile/custom_profile_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchTextEditingController = TextEditingController();
  int currentPageIndex = 0;
  FirebaseServices firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150),
          child: customAppBarLocation(searchTextEditingController),
        ),
        body: [
          Column(
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, crossAxisSpacing: 10),
                    children: [
                      customHomeCard(
                          image: "assets/images/track_truck.png",
                          title: "Track Garbage Truck",
                          voidCallback: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChooseAndTrackTruck(),
                              ),
                            );
                          }),
                      customHomeCard(
                          image: "assets/images/complaints.png",
                          title: "Complaints",
                          voidCallback: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ComplaintScreen(),
                              ),
                            );
                          }),
                      customHomeCard(
                          image: "assets/images/bins_around.png",
                          title: "Bins around you",
                          voidCallback: () {
                            FocusScope.of(context).unfocus();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BinsAroundYou(),
                              ),
                            );
                          }),
                      customHomeCard(
                          image: "assets/images/schedule.png",
                          title: "Collection Schedule",
                          voidCallback: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CollectionScheduleScreen(),
                              ),
                            );
                          }),
                      customHomeCard(
                          image: "assets/images/helpline.png",
                          title: "Helpline",
                          voidCallback: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const HelplineScreen()));
                          }),
                    ],
                  ),
                ),
              )
            ],
          ),
          Text("$currentPageIndex"),
          Text("$currentPageIndex"),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 38.0, horizontal: 18.0),
            child: Column(
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 8,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              spreadRadius: 2,
                              blurStyle: BlurStyle.outer),
                          BoxShadow(color: Colors.white),
                        ]),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: primary.shade400,
                      backgroundImage:
                          const AssetImage("assets/images/profile_image.jpeg"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    "Rudransh Singh Mahra",
                    style: GoogleFonts.nunito(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                customCardProfile(
                    Icons.account_circle_outlined, "My Account", () {}),
                customCardProfile(Icons.settings_outlined, "Settings", () {}),
                customCardProfile(Icons.logout, "Log Out", () {
                  firebaseServices.logOut(context);
                }),
              ],
            ),
          )
        ][currentPageIndex],
        bottomNavigationBar: NavigationBar(
          elevation: 5,
          backgroundColor: Colors.white,
          height: 60,
          animationDuration: const Duration(milliseconds: 1800),
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: ""),
            NavigationDestination(
                icon: Icon(Icons.travel_explore_outlined), label: ""),
            NavigationDestination(icon: Icon(Icons.recycling), label: ""),
            NavigationDestination(icon: Icon(Icons.person), label: ""),
          ],
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        ),
      ),
    );
  }
}
