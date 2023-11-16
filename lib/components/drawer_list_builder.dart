import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerListWidget extends StatefulWidget {
  
  const DrawerListWidget({super.key});

  @override
  State<DrawerListWidget> createState() => _DrawerListWidgetState();
}

class _DrawerListWidgetState extends State<DrawerListWidget> {
  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      // signed in
      return ListTile(
        enabled: true,
        onTap: () {
          signOut();
        },
        leading: const Icon(Icons.logout_rounded),
        title: const Text("Log out"),
      );
      // return Placeholder();
    } else {
      // signed out
      // return const LoginWidget();
      return const ListTile(
        enabled: false,
        leading: Icon(Icons.logout_rounded),
        title: Text("Log Out"),
      );
    }
  }
}
