import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_bin_sense/constants.dart';
import 'package:smart_bin_sense/services/firebase_services.dart';
import 'package:smart_bin_sense/views/complaintFiledSuccess.dart';
import 'package:smart_bin_sense/widgets/appbar/customAppbarOnlyTitle.dart';

class FileComplaintScreen extends StatefulWidget {
  const FileComplaintScreen({super.key});

  @override
  State<FileComplaintScreen> createState() => _FileComplaintScreenState();
}

class _FileComplaintScreenState extends State<FileComplaintScreen> {
  String? locationDropdownValue;
  String? categoryDropdownValue;
  String? selectedLocation;
  String? selectedCategory;
  TextEditingController descriptionController = TextEditingController();
  FirebaseServices firebaseServices = FirebaseServices();
  XFile? _image;

  List<String> locationList = [
    'Delhi NCR',
    'Hyderabad',
    'Bengaluru',
    'Mumbai',
    "Chennai",
    "Gujarat",
    "Assam",
    "West Bengal"
  ];

  List<String> complaintCategoryList = [
    'Garbage vehicle not arrived',
    'Dustin not cleaned',
    'Garbage burning',
    'Dead Animal',
    "Garbage dump",
    "Sweeping not done",
    "Open Defecation",
  ];

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
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff5c964a),
      child: SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: customAppbarOnlyTitle("Complaints", context),
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(left: 12.0, right: 12, top: 28, bottom: 18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "File your complaint",
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, right: 8.0, top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Color(0xffffae0c),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Text(
                                  "Select a location",
                                  style: GoogleFonts.nunito(),
                                ),
                              )
                            ],
                          ),
                          DropdownButton(
                              style: GoogleFonts.nunito(
                                  color: Colors.black, fontSize: 11),
                              alignment: Alignment.centerRight,
                              value: locationDropdownValue,
                              items: locationList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  locationDropdownValue = value!;
                                  selectedLocation = locationDropdownValue;
                                });
                              })
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, right: 8.0, top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.category,
                                color: Color(0xffffae0c),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Text(
                                  "Choose Category",
                                  style: GoogleFonts.nunito(),
                                ),
                              )
                            ],
                          ),
                          DropdownButton(
                            style: GoogleFonts.nunito(
                                color: Colors.black, fontSize: 11),
                            value: categoryDropdownValue,
                            alignment: Alignment.centerRight,
                            items: complaintCategoryList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                categoryDropdownValue = value!;
                                selectedCategory = categoryDropdownValue;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 20, bottom: 11),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.note_alt_rounded,
                                color: Color(0xffffae0c),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Text(
                                  "Add Description",
                                  style: GoogleFonts.nunito(),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                      decoration: const InputDecoration(
                          hintText: "Enter description here"),
                      controller: descriptionController,
                      maxLines: 3,
                      style: GoogleFonts.nunito(),
                    ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(38.0),
                  child: Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _pickImage();
                          },
                          child: _image == null
                              ? const Icon(
                                  Icons.camera_alt,
                                  size: 80,
                                  color: Color(0xfffbb700),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  height: 200,
                                  child: Image.file(
                                    File(_image!.path),
                                    fit: BoxFit.fill,
                                  )),
                        ),
                        if (_image == null)
                          Text(
                            "Upload picture",
                            style:
                                GoogleFonts.nunito(fontWeight: FontWeight.bold),
                          )
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                        onPressed: () {
                          if (selectedCategory != null &&
                              selectedLocation != null &&
                              descriptionController.text.isNotEmpty &&
                              _image != null) {
                            firebaseServices
                                .uploadImageToStorage(
                                    _image, "complaint_images")
                                .then((imageUrl) {
                              if (imageUrl != null) {
                                firebaseServices
                                    .addComplaintToDatabase(
                                        selectedLocation.toString(),
                                        selectedCategory.toString(),
                                        descriptionController.text,
                                        imageUrl)
                                    .then((value) {
                                  showCustomToast(
                                      "Complaint filed successfully");
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ComplaintFiledSuccessScreen()),
                                  );
                                });
                              }
                            });
                          } else {
                            showCustomToast("Provide the required details");
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 38.0),
                          child: Text(
                            "Done",
                            style: GoogleFonts.nunito(fontSize: 16),
                          ),
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
