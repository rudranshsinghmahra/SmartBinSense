import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_bin_sense/widgets/appbar/customAppbarOnlyTitle.dart';
import 'package:smart_bin_sense/widgets/helpline/customHelplineCardOne.dart';

import '../widgets/complaints/customComplaintCard.dart';
import '../widgets/complaints/customLatestComplaintCard.dart';
import 'file_complaint_screen.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  int numberOfComplaints = 0;

  Future<void> getNoOfComplaints() async {
    QuerySnapshot snapshot = await firebaseServices.complaint.get();
    if (snapshot.docs.isNotEmpty) {
      int numberOfComplaints = snapshot.docs.length;
      setState(() {
        this.numberOfComplaints = numberOfComplaints;
      });
    }
  }

  @override
  void initState() {
    getNoOfComplaints();
    super.initState();
  }

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
            }, false, numberOfComplaints),
            customComplaintCard(
                "Previous complaint", () {}, true, numberOfComplaints),
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
              child: StreamBuilder(
                stream: firebaseServices.complaint.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return customLatestComplaintCard(
                          data['imageUrl'], data['category'], data['location']);
                    }).toList(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    ));
  }
}
