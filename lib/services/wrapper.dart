import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vartarevarta_magazine/screens/login.dart';
import 'package:vartarevarta_magazine/screens/navigation_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      // signed in
      return const NavigatonBarWidget();
      // return Placeholder();
    } else {
      // signed out
      // return const LoginWidget();
      return const LoginWidget();
      // return const CircularProgressIndicator.adaptive();
    }
  }
}
