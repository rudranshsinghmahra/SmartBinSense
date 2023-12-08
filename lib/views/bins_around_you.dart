import 'package:flutter/material.dart';
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

  @override
  void initState() {
    addCustomIcon();
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
