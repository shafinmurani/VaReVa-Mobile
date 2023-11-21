import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  String url = "";
  getDownloadUrl() async {
    await FirebaseStorage.instance
        .ref()
        .child("Privacy Policy - VRV.pdf")
        .getDownloadURL()
        .then((value) {
      setState(() {
        url = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getDownloadUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Privacy Policy"),
      ),
      body: url != ""
          ? const PDF(
              swipeHorizontal: true,
            ).cachedFromUrl(url)
          : const Center(
              child: Text("Loading..."),
            ),
    );
  }
}
