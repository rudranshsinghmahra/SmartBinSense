import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:firebase_database/firebase_database.dart';

class MapsReceiver extends StatefulWidget {
  final String deviceId;

  const MapsReceiver({Key? key, required this.deviceId}) : super(key: key);

  @override
  State createState() => MapsReceiverState();
}

class MapsReceiverState extends State<MapsReceiver> {
  static final databaseReference = FirebaseDatabase.instance.ref();
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  static double currentLatitude = 0.0;
  static double currentLongitude = 0.0;
  List<String> list = [];
  static GoogleMapController? mapController;
  double heading = 0.0;

  StreamSubscription? subscription;

  Map<String, double> currentLocation = {};
  StreamSubscription<Map<String, double>>? locationSubscription;

  Location location = Location();
  String? error;
  Set<Marker> markers = {};

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    addCustomIcon();
    databaseReference.once().then((snapshot) {
      Map<dynamic, dynamic> values = snapshot.snapshot.value as Map;
      values.forEach((key, values) {
        setState(() {
          list.add(key);
        });
      });
    });

    subscription = FirebaseDatabase.instance
        .ref()
        .child(widget.deviceId)
        .onValue
        .listen((event) {
      setState(() {
        currentLatitude = (event.snapshot.value as Map)['latitude'];
        currentLongitude = ((event.snapshot.value as Map)['longitude']);
        heading = ((event.snapshot.value as Map)['heading']);
      });
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(
                (event.snapshot.value as Map)['latitude'],
                (event.snapshot.value as Map)['longitude'],
              ),
              zoom: 17),
        ),
      );
      markers = {
        Marker(
            markerId: const MarkerId("currentLocation"),
            icon: markerIcon,
            position: LatLng(
              (event.snapshot.value as Map)['latitude'],
              (event.snapshot.value as Map)['longitude'],
            ),
            rotation: heading),
      };
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(),
            "assets/images/garbage_truck_marker.png")
        .then((icon) {
      setState(() {
        markerIcon = icon;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receiver')),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: 350.0,
              child: GoogleMap(
                mapType: MapType.satellite,
                markers: markers,
                initialCameraPosition: CameraPosition(
                    target: LatLng(currentLatitude, currentLongitude),
                    zoom: 17),
                onMapCreated: _onMapCreated,
              ),
            ),
            Text('Lat/Lng: $currentLatitude/$currentLongitude'),
            Text("Device ID: ${widget.deviceId}"),
            SizedBox(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MapsReceiver(deviceId: list[index])),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 30,
                          child: Text('${list[index].length}'),
                        ),
                      ),
                    );
                  },
                  itemCount: list.length),
            )
          ],
        ),
      ),
    );
  }
}
