import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:no_screenshot/no_screenshot.dart';

class ViewPDF extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final int pageNum;
  final String name;
  final String path;
  final String id;
  // ignore: prefer_typing_uninitialized_variables
  const ViewPDF(
      {super.key,
      required this.pageNum,
      required this.name,
      required this.path,
      required this.id});
  @override
  // ignore: library_private_types_in_public_api
  _ViewPDFState createState() => _ViewPDFState();
}

class _ViewPDFState extends State<ViewPDF> {
  final _noScreenshot = NoScreenshot.instance;

  disableScreenshot() async {
    await _noScreenshot.screenshotOff();
  }

  enableScreenshot() async {
    await _noScreenshot.screenshotOn();
  }

  @override
  void initState() {
    super.initState();
    disableScreenshot();
  }

  @override
  void dispose() {
    super.dispose();
    enableScreenshot();
  }

  @override
  Widget build(BuildContext context) {
    updatePage(value, path) {
      var collection = FirebaseFirestore.instance.collection('/data');

      collection
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({"Read.${widget.id}": value});
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: PDF(
                fitPolicy: FitPolicy.BOTH,
                swipeHorizontal: true,
                defaultPage: widget.pageNum,
                // fitPolicy: FitPolicy.BOTH,
                autoSpacing: true,
                pageSnap: true,
                enableSwipe: true,
                onPageChanged: (page, total) => updatePage(page, widget.name),
                preventLinkNavigation: true)
            .cachedFromUrl(
          widget.path,
          placeholder: (double progress) => Center(
            child: CircularProgressIndicator(
              value: (progress / 100),
            ),
          ),
          errorWidget: (dynamic error) => Center(child: Text(error.toString())),
        ));
  }
}
