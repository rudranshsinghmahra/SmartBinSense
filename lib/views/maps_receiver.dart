import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smart_bin_sense/services/firebase_services.dart';
import 'package:shimmer/shimmer.dart';

class MapsReceiver extends StatefulWidget {
  final String deviceId;
  final String truckerName;
  final String truckerProfilePicture;

  const MapsReceiver(
      {super.key,
      required this.deviceId,
      required this.truckerName,
      required this.truckerProfilePicture});

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
  FirebaseServices firebaseServices = FirebaseServices();

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

    subscription = databaseReference
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
    return Container(
      color: const Color(0xff5c964a),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.green.shade50,
          appBar: AppBar(title: const Text('Receiver')),
          body: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.63,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: GoogleMap(
                      mapType: MapType.normal,
                      markers: markers,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(currentLatitude, currentLongitude),
                        zoom: 17,
                      ),
                      onMapCreated: _onMapCreated,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      MapsReceiver(
                                deviceId: list[index],
                                truckerProfilePicture:
                                    widget.truckerProfilePicture,
                                truckerName: widget.truckerName,
                              ),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0, top: 10),
                          child: Column(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 2),
                                  borderRadius: BorderRadius.circular(200),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(200),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: widget.truckerProfilePicture,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: 80,
                                        // Set desired width
                                        height: 80,
                                        // Set desired height
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.truckerName.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
