import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: customAppbarOnlyTitle("Complaints", context),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 18.0, right: 18, top: 28, bottom: 18),
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
                            items: locationList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                locationDropdownValue = value!;
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
                                "Choose a Category",
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
                      const Icon(
                        Icons.camera_alt,
                        size: 80,
                        color: Color(0xfffbb700),
                      ),
                      Text(
                        "Upload picture",
                        style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
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
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ComplaintFiledSuccessScreen()),
                        );
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
    ));
  }
}
