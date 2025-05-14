import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_bin_sense/views/maps_receiver.dart';
import 'package:smart_bin_sense/widgets/appbar/customAppbarOnlyTitle.dart';
import 'package:smart_bin_sense/widgets/helpline/customHelplineCardOne.dart';
import 'package:smart_bin_sense/widgets/truck_driver/truckDriverCustomCard.dart';

class ChooseAndTrackTruck extends StatefulWidget {
  const ChooseAndTrackTruck({super.key});

  @override
  State<ChooseAndTrackTruck> createState() => _ChooseAndTrackTruckState();
}

class _ChooseAndTrackTruckState extends State<ChooseAndTrackTruck> {
  static final databaseReference = FirebaseDatabase.instance.ref();
  StreamSubscription? subscription;
  Map<String, double> currentLocation = {};
  StreamSubscription<Map<String, double>>? locationSubscription;
  String? error;
  List<String> list = [];

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    databaseReference.once().then((snapshot) {
      if (snapshot.snapshot.exists) {
        Map<dynamic, dynamic> values = snapshot.snapshot.value as Map;
        values.forEach((key, values) {
          setState(() {
            list.add(key);
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff5c964a),
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: customAppbarOnlyTitle("Track Garbage Truck", context),
          ),
          body: list.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      child: FutureBuilder(
                        future: firebaseServices.getTruckDriverDetails(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DataSnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text("Error fetching data"));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.value == null) {
                            return const Center(child: Text("No data found"));
                          }

                          Map<dynamic, dynamic> values =
                              snapshot.data!.value as Map<dynamic, dynamic>;

                          return ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              String name =
                                  values[list[index]]['name'] ?? "Name not set";
                              String deviceId = values[list[index]]
                                      ['deviceId'] ??
                                  "Id not set";
                              String plateNumber = values[list[index]]
                                      ['plateNumber'] ??
                                  "Plate number not set";
                              String phoneNumber = values[list[index]]
                                      ['phoneNumber'] ??
                                  "Phone number not set";
                              String homeAddress = values[list[index]]
                                      ['address'] ??
                                  "Home address not set";
                              String imageUrl =
                                  values[list[index]]['imageUrl'] ?? "";

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapsReceiver(
                                        deviceId: list[index],
                                        truckerName: name,
                                        truckerProfilePicture: imageUrl,
                                      ),
                                    ),
                                  );
                                },
                                child: truckDriverCustomCard(
                                    context: context,
                                    deviceId: deviceId,
                                    name: name,
                                    plateNumber: plateNumber,
                                    phoneNumber: phoneNumber,
                                    homeAddress: homeAddress,
                                    imageUrl: imageUrl),
                              );
                            },
                            itemCount: list.length,
                          );
                        },
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Text(
                    "No truck drivers founds",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
        ),
      ),
    );
  }
}
