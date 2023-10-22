import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:internet_file/internet_file.dart';

class PdfWidget extends StatefulWidget {
  const PdfWidget({super.key});

  @override
  State<PdfWidget> createState() => _PdfWidgetState();
}

class _PdfWidgetState extends State<PdfWidget> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> downloadURLExample() async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('/second_vol.pdf')
        .getDownloadURL();

    final pdfPinchController = PdfControllerPinch(
        document: PdfDocument.openData(InternetFile.get(downloadURL)));
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewPDF(pdfPinchController),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: downloadURLExample,
        child: const Text("Open Pdf"),
      ),
    );
  }
}

class ViewPDF extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final document;
  const ViewPDF(this.document, {super.key});
  @override
  // ignore: library_private_types_in_public_api
  _ViewPDFState createState() => _ViewPDFState();
}

class _ViewPDFState extends State<ViewPDF> {
  @override
  Widget build(BuildContext context) {
    return PdfViewPinch(
      controller: widget.document,
      // scrollDirection: Axis.horizontal,
    );
  }
}
