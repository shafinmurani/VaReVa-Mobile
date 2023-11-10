import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:pdfx/pdfx.dart';
import 'package:vartarevarta_magazine/components/colors.dart';
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
    PDFDocument doc = await PDFDocument.fromURL("${widget.path}.pdf");
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: "Opening PDF "),
        builder: (context) => ViewPDF(
          doc,
          path,
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
    return const Center(child: CircularProgressIndicator.adaptive());
  }
}

class ViewPDF extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final document;
  final int pageNum;
  final String name;
  // ignore: prefer_typing_uninitialized_variables
  final path;
  const ViewPDF(this.document, this.path,
      {super.key, required this.pageNum, required this.name});
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
      appBar: AppBar(),
      body: PDFViewer(
        document: widget.document,
        indicatorText: secondary,
        indicatorBackground: primary,
        controller: PageController(initialPage: widget.pageNum),
        lazyLoad: false,
        pickerButtonColor: primary,
        pickerIconColor: Colors.brown[800],
        indicatorPosition: IndicatorPosition.bottomRight,
        showPicker: false,
        onPageChanged: (value) => updatePage(value, widget.path),
      ),
    );
  }
}
