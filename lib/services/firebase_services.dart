import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_bin_sense/views/log_in_screen.dart';
import 'package:smart_bin_sense/views/otp_verify_screen.dart';

class FirebaseServices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CollectionReference bins = FirebaseFirestore.instance.collection("bins");
  CollectionReference schedule =
      FirebaseFirestore.instance.collection("schedule");
  CollectionReference helpline =
      FirebaseFirestore.instance.collection("helpline");
  CollectionReference complaint =
      FirebaseFirestore.instance.collection("complaint");
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: "+91${phoneNumber.toString().trim()}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          if (kDebugMode) {
            print('The provided phone number is not valid.');
          }
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Logout successful. See you again!",
              style: GoogleFonts.nunito(color: Colors.black),
            ),
            backgroundColor: Colors.grey.shade400,
          )),
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
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<List<LatLng>> fetchBins() async {
    List<LatLng> binsLocationList = [];
    try {
      QuerySnapshot querySnapshot = await bins.get();
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
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

  Future<void> addContactToDatabase(String name, String phoneNumber) async {
    await helpline.doc().set({
      "name": name.trim(),
      "phoneNumber": phoneNumber.trim(),
      "userId": user?.uid,
    });
  }

  Future<void> deleteContactFromDatabase(String docId) async {
    await helpline.doc(docId).delete();
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

  Future<String?> uploadImageToStorage(XFile? image) async {
    try {
      if (image != null) {
        final Reference storageRef = FirebaseStorage.instance.ref().child(
              'complaint_images/${DateTime.now().millisecondsSinceEpoch}.jpg',
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
}
