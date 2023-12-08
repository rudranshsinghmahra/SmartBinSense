import 'package:flutter/material.dart';
import 'package:smart_bin_sense/widgets/appbar/customAppbarOnlyTitle.dart';

class FileComplaintScreen extends StatefulWidget {
  const FileComplaintScreen({super.key});

  @override
  State<FileComplaintScreen> createState() => _FileComplaintScreenState();
}

class _FileComplaintScreenState extends State<FileComplaintScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: customAppbarOnlyTitle("Complaints", context),
      ),
    ));
  }
}
