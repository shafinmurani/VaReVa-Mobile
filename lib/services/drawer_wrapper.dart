import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vartarevarta_magazine/components/colors.dart';

class DrawerWrapper extends StatefulWidget {
  const DrawerWrapper({super.key});

  @override
  State<DrawerWrapper> createState() => _DrawerWrapperState();
}

class _DrawerWrapperState extends State<DrawerWrapper> {
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      // signed in

      return DrawerHeader(
        decoration: const BoxDecoration(
          color: appBar,
        ),
        child: Text(
          "Welcome back, ${FirebaseAuth.instance.currentUser?.displayName}!",
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      );

      // return Placeholder();
    } else {
      // signed out
      // return const LoginWidget();
      return const DrawerHeader(
        decoration: BoxDecoration(
          color: appBar,
        ),
        child: Text('Welcome!'),
      );
      // return const CircularProgressIndicator.adaptive();
    }
  }
}
