import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_bin_sense/chooseAndTrackTruck.dart';
import 'package:smart_bin_sense/colors.dart';
import 'package:smart_bin_sense/services/firebase_services.dart';
import 'package:smart_bin_sense/views/bins_around_you.dart';
import 'package:smart_bin_sense/views/collection_schedule_screen.dart';
import 'package:smart_bin_sense/views/complaints_screen.dart';
import 'package:smart_bin_sense/views/file_complaint_screen.dart';
import 'package:smart_bin_sense/views/helpline_screen.dart';
import 'package:smart_bin_sense/views/my_account_screen.dart';
import 'package:smart_bin_sense/widgets/blogPostCard.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/appbar/custom_appbar_location.dart';
import '../widgets/home/custom_home_card.dart';
import '../widgets/profile/custom_profile_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
  FirebaseServices firebaseServices = FirebaseServices();
  User? user = FirebaseAuth.instance.currentUser;

  String formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return formattedDate;
  }

  Future<void> launchBlogURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print('Error: Could not launch $url');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff5c964a),
      child: SafeArea(
        child: Scaffold(
          appBar: const PreferredSize(
              preferredSize: Size.fromHeight(150),
              child: CustomAppbarLocation()),
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
                            fontSize: 25),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FileComplaintScreen(),
                            ),
                          );
                        },
                        child: Column(
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
                        ),
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
                                builder: (context) => const HelplineScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
                height: MediaQuery.of(context).size.height,
                color: const Color(0xfff1f0f3),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, left: 12.0, bottom: 8, right: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Latest Blogs (Must Read)",
                                  style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder(
                          future: firebaseServices.fetchAllBlogs(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(50.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            if (!snapshot.hasData) {
                              return const Center(
                                child: Text(
                                  "No blogs available",
                                ),
                              );
                            }
                            if (snapshot.hasData) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data?.length,
                                itemBuilder: (context, index) {
                                  String formattedDate = formatTimestamp(
                                      snapshot.data?[index]["postDate"]);
                                  return InkWell(
                                    onTap: () {
                                      launchBlogURL(
                                          snapshot.data?[index]["blogLink"]);
                                    },
                                    child: blogPostCard(
                                        imageUrl: snapshot.data?[index]
                                            ["imageUrl"],
                                        description: snapshot.data?[index]
                                            ["description"],
                                        postedOn: formattedDate,
                                        title: snapshot.data?[index]["title"]),
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                child: Text("No data found"),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )),
            Column(
              children: [
                FutureBuilder(
                    future: firebaseServices.getAccountDetails(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      // Error state
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData) {
                        return const Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Center(
                              child: Text(
                            "Profile and Name data not found.\nUpdate in My Account",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          )),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 38.0, horizontal: 18.0),
                        child: Column(
                          children: [
                            Center(
                              child: Container(
                                height: 220,
                                width: 220,
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
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(200),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: snapshot.data!['imageUrl'] ??
                                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(200),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: Text(
                                snapshot.data?['name'] ?? "Please set name",
                                style: GoogleFonts.nunito(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                customCardProfile(Icons.account_circle_outlined, "My Account",
                    () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyAccountScreen()));
                }),
                customCardProfile(Icons.logout, "Log Out", () {
                  firebaseServices.logOut(context);
                }),
              ],
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
              NavigationDestination(icon: Icon(Icons.recycling), label: ""),
              NavigationDestination(icon: Icon(Icons.person), label: ""),
            ],
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          ),
        ),
      ),
    );
  }
}
