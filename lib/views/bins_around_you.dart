import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:smart_bin_sense/services/firebase_services.dart';
import 'package:smart_bin_sense/widgets/appbar/customAppbarOnlyTitle.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BinsAroundYou extends StatefulWidget {
  const BinsAroundYou({super.key});

  @override
  State<BinsAroundYou> createState() => _BinsAroundYouState();
}

class _BinsAroundYouState extends State<BinsAroundYou> {
  LatLng initialPosition = const LatLng(28.529664049911293, 77.25394014116245);
  FirebaseServices firebaseServices = FirebaseServices();
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  List<LatLng> binsLocationList = [];
  Set<Marker> markers = {};
  final Location _locationController = Location();
  late StreamSubscription<LocationData> _locationSubscription;
  late GoogleMapController _mapController;
  bool fetchingLocation = false;

  @override
  void initState() {
    addCustomIcon();
    getLocationUpdates();
    firebaseServices.fetchBins().then((binsList) {
      setState(() {
        binsLocationList = binsList;
        markers = {};
        for (int i = 0; i < binsLocationList.length; i++) {
          markers.add(
            Marker(
              markerId: MarkerId("bin_$i"),
              icon: markerIcon,
              position: binsLocationList[i],
            ),
          );
        }
      });
    });
    super.initState();
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/dustbin.png")
        .then((icon) {
      setState(() {
        markerIcon = icon;
      });
    });
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionStatus;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) return;
    }

    permissionStatus = await _locationController.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _locationController.requestPermission();
      if (permissionStatus != PermissionStatus.granted) return;
    }

    _locationSubscription = _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        if (mounted) {
          setState(() {
            initialPosition =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
          });
        }
      }
    });
  }

  void _goToCurrentLocation() async {
    setState(() {
      fetchingLocation = true;
    });

    try {
      final LocationData location = await _locationController.getLocation();
      _mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(location.latitude!, location.longitude!),
        ),
      );
    } catch (e) {
      print("Error getting location: $e");
    } finally {
      setState(() {
        fetchingLocation = false;
      });
    }
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff5c964a),
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                myLocationEnabled: true,
                mapType: MapType.satellite,
                myLocationButtonEnabled: false,
                // Disable default button
                initialCameraPosition:
                    CameraPosition(target: initialPosition, zoom: 15),
                markers: markers,
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: customAppbarOnlyTitle(
                  "Bins around you",
                  context,
                ),
              ),
              Positioned(
                bottom: 40,
                left: 16,
                child: FloatingActionButton(
                  onPressed: _goToCurrentLocation,
                  child: fetchingLocation
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Icon(Icons.my_location),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
