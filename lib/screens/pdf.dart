import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// import 'package:pdfx/pdfx.dart';
// import 'package:vartarevarta_magazine/components/colors.dart';
// import 'package:internet_file/internet_file.dart';

class PdfWidget extends StatefulWidget {
  final String path;
  final String name;
  const PdfWidget({super.key, required this.path, required this.name});

  @override
  State<PdfWidget> createState() => _PdfWidgetState();
}

class _PdfWidgetState extends State<PdfWidget> {
  dynamic snapShot;
  int pageNum = 0;
  getData(String productName) async {
    snapShot = await FirebaseFirestore.instance
        .collection('/data')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    if (snapShot["Read"][productName] != null) {
      setState(() {
        pageNum = snapShot["Read"][productName];
      });
      return true;
    } else {
      return false;
    }
  }

  Future<void> downloadURLExample(String path) async {
    await getData(widget.name);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: "Opening PDF "),
        builder: (context) => ViewPDF(
          path: path,
          pageNum: pageNum,
          name: widget.name,
        ),
      ),
    );
  }

  @override
  void initState() {
    downloadURLExample(widget.path);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Lottie.asset("assets/anim/loadin.json"));
  }
}

class ViewPDF extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final int pageNum;
  final String name;
  final String path;

  // ignore: prefer_typing_uninitialized_variables
  const ViewPDF(
      {super.key,
      required this.pageNum,
      required this.name,
      required this.path});
  @override
  // ignore: library_private_types_in_public_api
  _ViewPDFState createState() => _ViewPDFState();
}

class _ViewPDFState extends State<ViewPDF> {
  @override
  Widget build(BuildContext context) {
    updatePage(value, path) {
      var collection = FirebaseFirestore.instance.collection('/data');

      collection
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({"Read.${widget.name}": value});
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: PDF(
          swipeHorizontal: true,
          defaultPage: widget.pageNum,
          // fitPolicy: FitPolicy.BOTH,
          autoSpacing: true,
          enableSwipe: true,
          onPageChanged: (page, total) => updatePage(page, widget.name),
        ).cachedFromUrl(
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
