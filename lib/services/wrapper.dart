import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vartarevarta_magazine/screens/home/home_screen.dart';
import 'package:vartarevarta_magazine/screens/auth/login.dart';

class WrapperWidget extends StatefulWidget {
  const WrapperWidget({super.key});

  @override
  State<WrapperWidget> createState() => _WrapperWidgetState();
}

class _WrapperWidgetState extends State<WrapperWidget> {
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      setState(() {});
    });
  }

  Future checkAndCreateDocument(String? docID, name, email) async {
    final snapShot =
        await FirebaseFirestore.instance.collection('/data').doc(docID).get();

    var collection = FirebaseFirestore.instance.collection('/data');
    if (!snapShot.exists) {
      // docuement is not exist
      collection
          .doc(docID)
          .set({"Name": name, "Email address": email, "Purchased": []});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      // signed in
      checkAndCreateDocument(
          FirebaseAuth.instance.currentUser?.uid,
          FirebaseAuth.instance.currentUser?.displayName,
          FirebaseAuth.instance.currentUser?.email);
      return const HomeScreen();

      // return Placeholder();
    } else {
      // signed out
      // return const LoginWidget();
      return const LoginWidget();
      // return const CircularProgressIndicator.adaptive();
    }
  }
}
