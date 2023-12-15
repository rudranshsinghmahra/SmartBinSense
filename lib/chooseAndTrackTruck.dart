import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_bin_sense/views/maps_receiver.dart';
import 'package:smart_bin_sense/widgets/appbar/customAppbarOnlyTitle.dart';

class ChooseAndTrackTruck extends StatefulWidget {
  const ChooseAndTrackTruck({super.key});

  @override
  State<ChooseAndTrackTruck> createState() => _ChooseAndTrackTruckState();
}

class _ChooseAndTrackTruckState extends State<ChooseAndTrackTruck> {
  static final databaseReference = FirebaseDatabase.instance.ref();

  static double currentLatitude = 0.0;
  static double currentLongitude = 0.0;

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
      body: Column(
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
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          height: 50,
                          width: 240,
                          child: Text('Device ID : ${list[index]}'),
                        ),
                      ),
                    );
                  },
                  itemCount: list.length))
        ],
      ),
    ));
  }
}
