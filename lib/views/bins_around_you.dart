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
    if (serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    permissionStatus = await _locationController.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _locationController.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
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

  @override
  void dispose() {
    _locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: customAppbarOnlyTitle("Bins around you", context),
        ),
        body: Column(
          children: [
            Expanded(
              child: GoogleMap(
                myLocationEnabled: true,
                mapType: MapType.satellite,
                myLocationButtonEnabled: true,
                initialCameraPosition:
                    CameraPosition(target: initialPosition, zoom: 15),
                markers: markers,
              ),
            )
          ],
        ),
      ),
    );
  }
}
