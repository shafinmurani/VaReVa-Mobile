import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:vartarevarta_magazine/components/colors.dart';

class AboutWidget extends StatefulWidget {
  const AboutWidget({super.key});

  @override
  State<AboutWidget> createState() => _AboutWidgetState();
}

class _AboutWidgetState extends State<AboutWidget> {
  String downloadUrl = "";
  bool isData = false;

  getDownloadUrl() async {
    await FirebaseStorage.instance
        .ref()
        .child("about.pdf")
        .getDownloadURL()
        .then((value) {
      setState(() {
        downloadUrl = value;
        isData = true;
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
          title: const Text("અમારા વિશે"),
          backgroundColor: appBar,
        ),
        body: isData
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Center(
                  child: const PDF(
                    pageSnap: true,
                    autoSpacing: true,
                    enableSwipe: true,
                    swipeHorizontal: true,
                  ).cachedFromUrl(downloadUrl),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
