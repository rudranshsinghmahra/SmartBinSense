import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_bin_sense/services/firebase_services.dart';
import 'package:smart_bin_sense/widgets/appbar/customAppbarOnlyTitle.dart';
import 'package:intl/intl.dart';

import '../widgets/collection_schedule/custom_collection_schedule_card.dart';

class CollectionScheduleScreen extends StatefulWidget {
  const CollectionScheduleScreen({super.key});

  @override
  State<CollectionScheduleScreen> createState() =>
      _CollectionScheduleScreenState();
}

class _CollectionScheduleScreenState extends State<CollectionScheduleScreen> {
  FirebaseServices firebaseServices = FirebaseServices();
  String? locationDropdownValue;
  String? docName;
  List<String> locationList = [
    'Delhi NCR',
    'Hyderabad',
    'Bengaluru',
    'Mumbai',
    "Chennai",
    "Gujarat",
    "Assam",
    "West Bengal"
  ];

  void setDocName() {
    if (locationDropdownValue == "Delhi NCR") {
      docName = 'delhi_ncr';
    }
    if (locationDropdownValue == "Hyderabad") {
      docName = 'hyderabad';
    }
    if (locationDropdownValue == "Bengaluru") {
      docName = 'delhi_ncr';
    }
    if (locationDropdownValue == "Mumbai") {
      docName = 'hyderabad';
    }
    if (locationDropdownValue == "Chennai") {
      docName = 'delhi_ncr';
    }
    if (locationDropdownValue == "Gujarat") {
      docName = 'hyderabad';
    }
    if (locationDropdownValue == "Assam") {
      docName = 'delhi_ncr';
    }
    if (locationDropdownValue == "West Bengal") {
      docName = 'hyderabad';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: customAppbarOnlyTitle("Collection Schedule", context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xffffae0c),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Text(
                              "Select a location",
                              style: GoogleFonts.nunito(),
                            ),
                          )
                        ],
                      ),
                      DropdownButton(
                          style: GoogleFonts.nunito(
                              color: Colors.black, fontSize: 11),
                          alignment: Alignment.centerRight,
                          value: locationDropdownValue,
                          items: locationList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              locationDropdownValue = value!;
                              setDocName();
                            });
                          })
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Current Week Schedule",
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: GoogleFonts.nunito(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Day",
                            style: GoogleFonts.nunito(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Expected Time",
                            style: GoogleFonts.nunito(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 350,
                      child: StreamBuilder(
                        stream:
                            firebaseServices.schedule.doc(docName).snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          Map<String, dynamic> data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          return ListView(
                            children: [
                              customCollectionScheduleCard(
                                  weekName: "Monday",
                                  timeStamp: data['Monday'],
                                  isToday: false),
                              customCollectionScheduleCard(
                                  weekName: "Tuesday",
                                  timeStamp: data['Tuesday'],
                                  isToday: false),
                              customCollectionScheduleCard(
                                  weekName: "Wednesday",
                                  timeStamp: data['Wednesday'],
                                  isToday: false),
                              customCollectionScheduleCard(
                                  weekName: "Thursday",
                                  timeStamp: data['Thursday'],
                                  isToday: false),
                              customCollectionScheduleCard(
                                  weekName: "Friday",
                                  timeStamp: data['Friday'],
                                  isToday: false),
                              customCollectionScheduleCard(
                                  weekName: "Saturday",
                                  timeStamp: data['Saturday'],
                                  isToday: false),
                              customCollectionScheduleCard(
                                  weekName: "Sunday",
                                  timeStamp: data['Sunday'],
                                  isToday: false),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
