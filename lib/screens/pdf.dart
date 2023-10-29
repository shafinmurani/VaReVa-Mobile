import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:pdfx/pdfx.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:internet_file/internet_file.dart';

class PdfWidget extends StatefulWidget {
  final String path;
  const PdfWidget({super.key, required this.path});

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
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(path)
        .getDownloadURL();

    PDFDocument doc = await PDFDocument.fromURL(downloadURL);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ViewPDF(
          doc,
          path,
          pageNum: pageNum,
        ),
      ),
    );
  }

  @override
  void initState() {
    getData(widget.path);
    downloadURLExample(widget.path);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator.adaptive());
  }
}

class ViewPDF extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final document;
  final int pageNum;
  // ignore: prefer_typing_uninitialized_variables
  final path;
  const ViewPDF(this.document, this.path, {super.key, required this.pageNum});
  @override
  // ignore: library_private_types_in_public_api
  _ViewPDFState createState() => _ViewPDFState();
}

updatePage(value, path) {
  var collection = FirebaseFirestore.instance.collection('/data');

  collection
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .update({"Read.$path": value});
}

class _ViewPDFState extends State<ViewPDF> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PDFViewer(
        document: widget.document,
        controller: PageController(initialPage: widget.pageNum),
        lazyLoad: false,
        onPageChanged: (value) => updatePage(value, widget.path),
      ),
    );
  }
}
