import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_bin_sense/widgets/appbar/customAppbarOnlyTitle.dart';

import '../constants.dart';
import '../widgets/helpline/customHelplineCardOne.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  XFile? _image;
  bool isUploadingData = false;
  String? networkImageUrl;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextStyle style = GoogleFonts.nunito();
  User? user = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot?> fetchUserData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('account')
          .doc(user!.uid)
          .get();
      return doc; // Directly access the 'imageUrl' field
    } catch (e) {
      print('Error fetching imageUrl: $e');
      return null;
    }
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take a photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedImage =
                      await picker.pickImage(source: ImageSource.camera);
                  if (pickedImage != null) {
                    setState(() {
                      _image = pickedImage;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Choose from gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedImage =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    setState(() {
                      _image = pickedImage;
                    });
                  }
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData().then((dSnapshot) {
      if (dSnapshot?.exists == true) {
        setState(() {
          networkImageUrl = dSnapshot?["imageUrl"];
          nameController.text = dSnapshot?['name'];
          emailController.text = dSnapshot?['email'];
          phoneController.text = dSnapshot?['phoneNumber'];
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
            preferredSize: const Size.fromHeight(100),
            child: customAppbarOnlyTitle("My Account", context),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.white, width: 5),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 0.6,
                              offset: Offset(-0.2, 0.2),
                              blurRadius: 3)
                        ]),
                    child: GestureDetector(
                      onTap: () {
                        _pickImage();
                      },
                      child: _image == null
                          ? (networkImageUrl?.isNotEmpty ??
                                  false) // Check if networkImageUrl is not null and not empty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    networkImageUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.camera_alt,
                                  size: 80,
                                )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: SizedBox(
                                width: double.infinity,
                                height: 200,
                                child: Image.file(
                                  File(_image!.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                TextField(
                  controller: nameController,
                  style: style,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: style,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  style: style,
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: style,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  style: style,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: style,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isUploadingData = true;
                          });
                          try {
                            if (nameController.text.isNotEmpty &&
                                    emailController.text.isNotEmpty &&
                                    phoneController.text.isNotEmpty &&
                                    _image != null ||
                                networkImageUrl != null) {
                              if (_image == null) {
                                firebaseServices
                                    .addAccountDetailsToDatabase(
                                        nameController.text,
                                        emailController.text,
                                        phoneController.text,
                                        networkImageUrl.toString())
                                    .then((value) {
                                  setState(() {
                                    isUploadingData = false;
                                  });
                                  showCustomToast(
                                      "Details uploaded successfully...");
                                });
                              } else {
                                firebaseServices
                                    .uploadImageToStorage(
                                        _image, "account_images")
                                    .then((imageUrl) {
                                  if (imageUrl != null) {
                                    firebaseServices
                                        .addAccountDetailsToDatabase(
                                            nameController.text,
                                            emailController.text,
                                            phoneController.text,
                                            imageUrl)
                                        .then((value) {
                                      setState(() {
                                        isUploadingData = false;
                                      });
                                      showCustomToast(
                                          "Details uploaded successfully...");
                                    });
                                  } else {
                                    showCustomToast("Failed to upload image");
                                  }
                                });
                              }
                            } else {
                              showCustomToast(
                                  "Please enter the required field(s)");
                            }
                          } catch (e) {
                            print("Error occurred ${e.toString()}");
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 12),
                          child: isUploadingData
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Text(
                                    'Submit',
                                    style: style,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
