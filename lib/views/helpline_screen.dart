import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_bin_sense/colors.dart';
import 'package:smart_bin_sense/constants.dart';
import 'package:smart_bin_sense/services/firebase_services.dart';
import 'package:smart_bin_sense/widgets/appbar/customAppbarOnlyTitle.dart';
import 'package:smart_bin_sense/widgets/helpline/customHelplineCardTwo.dart';

import '../widgets/helpline/customHelplineCardOne.dart';

class HelplineScreen extends StatefulWidget {
  const HelplineScreen({super.key});

  @override
  State<HelplineScreen> createState() => _HelplineScreenState();
}

class _HelplineScreenState extends State<HelplineScreen> {
  FirebaseServices firebaseServices = FirebaseServices();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff5c964a),
      child: SafeArea(
          child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: customAppbarOnlyTitle("Helpline", context)),
        body: Column(
          children: [
            StreamBuilder(
              stream: firebaseServices.helpline
                  .orderBy("name", descending: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  shrinkWrap: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return customHelplineCardOne(
                        data['name'],
                        data['phoneNumber'],
                        Icons.person,
                        document.id,
                        context);
                  }).toList(),
                );
              },
            ),
            Expanded(
              child: StreamBuilder(
                stream: firebaseServices.customContact
                    .where('userId', isEqualTo: firebaseServices.user?.uid)
                    .orderBy("name", descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return customHelplineCardTwo(data['name'],
                          data['phoneNumber'], Icons.person, document.id,context);
                    }).toList(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (kDebugMode) {
                        print("Hello");
                      }
                      showCustomDialogBox(context, nameController,
                          phoneController, firebaseServices);
                    },
                    child: const Icon(
                      Icons.person_add,
                      color: Color(0xffffb900),
                      size: 50,
                    ),
                  ),
                  Text(
                    "Add new contact",
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}

Future<void> showCustomDialogBox(
  BuildContext context,
  TextEditingController nameController,
  TextEditingController phoneController,
  FirebaseServices firebaseServices,
) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context,
            void Function(void Function()) statefulBuilder) {
          return AlertDialog(
            content: SizedBox(
              width: 300,
              height: 400,
              child: Column(
                children: [
                  const Text(
                    "Add Contact",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 28.0),
                    child: Icon(
                      Icons.person_add,
                      color: Color(0xfffcb503),
                      size: 100,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Enter name",
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primary.shade600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: phoneController,
                            maxLength: 10,
                            decoration: InputDecoration(
                              labelText: "Enter phone number",
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primary.shade600),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            firebaseServices
                                .addCustomContactToDatabase(
                                    nameController.text.trim(),
                                    phoneController.text.trim())
                                .then((value) {
                              showCustomToast("Contact added successfully");
                              nameController.clear();
                              phoneController.clear();
                              Navigator.pop(context);
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 3),
                            child: Text("Add"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
