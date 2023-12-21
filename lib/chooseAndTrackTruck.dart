import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_bin_sense/views/maps_receiver.dart';
import 'package:smart_bin_sense/widgets/appbar/customAppbarOnlyTitle.dart';
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
  String deviceId = 'Unknown';
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
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: customAppbarOnlyTitle("Track Garbage Truck", context),
      ),
      body: list.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapsReceiver(
                                deviceId: list[index],
                              ),
                            ),
                          );
                        },
                        child: truckDriverCustomCard(
                          context,
                          list[index],
                        ),
                      );
                    },
                    itemCount: list.length,
                  ),
                )
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    ));
  }
}
