import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vartarevarta_magazine/components/colors.dart';
import 'package:vartarevarta_magazine/screens/payment/payment_gateway.dart';
import 'package:vartarevarta_magazine/screens/pdf.dart';

class CheckPurchased extends StatefulWidget {
  final String productId;
  final String path;
  final int price;
  const CheckPurchased(
      {super.key,
      required this.productId,
      required this.path,
      required this.price});

  @override
  State<CheckPurchased> createState() => _CheckPurchasedState();
}

class _CheckPurchasedState extends State<CheckPurchased> {
  dynamic snapShot;
  bool? s;
  getData(String? docId, String productId) async {
    snapShot = await FirebaseFirestore.instance
        .collection('/data')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    if (snapShot["Purchased"].contains(productId)) {
      setState(() {
        s = true;
      });
    } else {
      setState(() {
        s = false;
      });
    }
  }

  @override
  void initState() {
    getData(FirebaseAuth.instance.currentUser?.uid, widget.productId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (s != null) {
      if (s == true) {
        return PdfWidget(
          path: widget.path,
          name: widget.productId,
        );
      } else if (s == false) {
        return PaymentWidget(
          productName: widget.productId,
          path: widget.path,
          price: widget.price,
        );
      }
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Loading..."),
        backgroundColor: primary,
      ),
      body: const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
