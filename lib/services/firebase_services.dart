import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:smart_bin_sense/views/log_in_screen.dart';
import 'package:smart_bin_sense/views/otp_verify_screen.dart';

class FirebaseServices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CollectionReference bins = FirebaseFirestore.instance.collection("bins");
  CollectionReference schedule =
      FirebaseFirestore.instance.collection("schedule");
  CollectionReference helpline =
      FirebaseFirestore.instance.collection("helpline");
  CollectionReference customContact =
      FirebaseFirestore.instance.collection("customContact");
  CollectionReference account =
      FirebaseFirestore.instance.collection("account");
  CollectionReference complaint =
      FirebaseFirestore.instance.collection("complaint");
  User? user = FirebaseAuth.instance.currentUser;
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: "+91${phoneNumber.toString().trim()}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerifyScreen(
              verificationId: verificationId,
            ),
          ),
        );
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> logOut(BuildContext context) async {
    await firebaseAuth.signOut().then((value) => {
          // showCustomToast("Logout successful. See you again!"),
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LogInScreen()))
        });
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<List<LatLng>> fetchBins() async {
    List<LatLng> binsLocationList = [];
    try {
      QuerySnapshot querySnapshot = await bins.get();
      for (QueryDocumentSnapshot queryDocSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data =
            queryDocSnapshot.data() as Map<String, dynamic>;
        data.forEach((key, value) {
          if (value is GeoPoint) {
            double latitude = value.latitude;
            double longitude = value.longitude;
            binsLocationList.add(LatLng(latitude, longitude));
          }
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
    return binsLocationList;
  }

  Future<void> addCustomContactToDatabase(
      String name, String phoneNumber) async {
    await customContact.doc().set({
      "name": name.trim(),
      "phoneNumber": phoneNumber.trim(),
      "userId": user?.uid,
    });
  }

  Future<void> addAccountDetailsToDatabase(
    String name,
    String email,
    String phoneNumber,
    String imageUrl,
  ) async {
    final DocumentReference userDocRef = account.doc(user!.uid);

    try {
      // Check if the user document exists
      final docSnapshot = await userDocRef.get();

      if (docSnapshot.exists) {
        // Document exists, so perform update
        await userDocRef.update({
          "name": name.trim(),
          "email": email.trim(),
          "phoneNumber": phoneNumber.trim(),
          "imageUrl": imageUrl,
        });
        print('Account details updated in existing document.');
      } else {
        // Document does not exist, so create it with set
        await userDocRef.set({
          "name": name.trim(),
          "email": email.trim(),
          "phoneNumber": phoneNumber.trim(),
          "imageUrl": imageUrl,
          "userId": user?.uid,
        });
        print('New account document created with details.');
      }
    } catch (e) {
      print('Error in addAccountDetailsToDatabase: $e');
    }
  }

  Future<String> getUserAddress() async {
    // Initialize location service and permissions
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return 'Location service is not enabled.';
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return 'Location permissions are not granted.';
      }
    }

    // Get current user location
    LocationData currentLocation = await location.getLocation();

    // Use geocoding to get the address
    List<geocoding.Placemark> placeMarks =
        await geocoding.placemarkFromCoordinates(
            currentLocation.latitude!.toDouble(),
            currentLocation.longitude!.toDouble());

    geocoding.Placemark firstPlaceMarks = placeMarks[0];

    // Return the formatted address
    return '${firstPlaceMarks.name},${firstPlaceMarks.subLocality},${firstPlaceMarks.postalCode}';
  }

  Future<void> setUserHomeLocationToDatabase({
    required String address,
  }) async {
    final DocumentReference userDocRef = account.doc(user!.uid);

    try {
      final docSnapshot = await userDocRef.get();

      if (docSnapshot.exists) {
        await userDocRef.update({
          "address": address.trim(),
        });
        print('Address updated in existing account document.');
      } else {
        await userDocRef.set({
          "address": address.trim(),
        });
        print('Account document created with address.');
      }
    } catch (e) {
      print('Error in setUserHomeLocationToDatabase: $e');
    }
  }

  Future<void> deleteContactFromDatabase(String docId) async {
    await customContact.doc(docId).delete();
  }

  Future<void> addComplaintToDatabase(String location, String category,
      String description, String imageUrl) async {
    await complaint.doc().set({
      "location": location.trim(),
      "category": category.trim(),
      "description": description,
      "imageUrl": imageUrl,
      "userId": user?.uid,
    });
  }

  Future<String?> uploadImageToStorage(
      XFile? image, String uploadFolderName) async {
    try {
      if (image != null) {
        final Reference storageRef = FirebaseStorage.instance.ref().child(
              '$uploadFolderName/${DateTime.now().millisecondsSinceEpoch}.jpg',
            );

        await storageRef.putFile(File(image.path));

        final String downloadURL = await storageRef.getDownloadURL();

        return downloadURL;
      }
    } catch (e) {
      print("Error uploading image to Firebase Storage: $e");
    }
    return null;
  }

  Future<DataSnapshot> getTruckDriverDetails() async {
    DataSnapshot dataSnapshot = await databaseReference.get();
    return dataSnapshot;
  }

  Future<Map<String, dynamic>?> getAccountDetails() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("account")
          .doc(user!.uid)
          .get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllBlogs() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("blogs").get();

      // Map each document snapshot to a Map<String, dynamic> and collect them in a list
      List<Map<String, dynamic>> blogs = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return blogs;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }
}
