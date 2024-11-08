import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_bin_sense/colors.dart';
import 'package:smart_bin_sense/services/firebase_services.dart';

class CustomAppbarLocation extends StatefulWidget {
  const CustomAppbarLocation({super.key});

  @override
  State<CustomAppbarLocation> createState() => _CustomAppbarLocationState();
}

class _CustomAppbarLocationState extends State<CustomAppbarLocation> {
  bool isLoading = false;
  FirebaseServices firebaseServices = FirebaseServices();
  String? userAddress = "Fetching address...";
  User? user = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot?> fetchUserAddress() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('account')
          .doc(user!.uid)
          .get();
      return doc; // Directly access the 'imageUrl' field
    } catch (e) {
      print('Error fetching imageUrl: $e');
      return null;
    }
  }

  @override
  void initState() {
    fetchUserAddress().then((dSnapshot) {
      if (dSnapshot?.exists == true) {
        setState(() {
          userAddress = dSnapshot?['address'];
        });
      } else {
        setState(() {
          userAddress = "Address not available";
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: double.infinity,
      decoration: BoxDecoration(
        color: primary.shade600,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 33,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLoading = true;
                        });
                        firebaseServices.getUserAddress().then((address) {
                          setState(() {
                            userAddress = address;
                            isLoading = false;
                          });
                          firebaseServices.setUserHomeLocationToDatabase(
                              address: address);
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Row(
                              children: [
                                Text(
                                  "Choose location",
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          isLoading
                              ? Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(
                                    height: 5,
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: const LinearProgressIndicator(
                                      color: Colors.yellow,
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(left: 3.0),
                                  child: Text(
                                    userAddress.toString(),
                                    style: GoogleFonts.nunito(
                                        color: Colors.white70, fontSize: 14),
                                  ),
                                )
                        ],
                      ),
                    )
                  ],
                ),
                const Badge(
                  label: Text("2"),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 33,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
