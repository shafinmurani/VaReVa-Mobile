import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vartarevarta_magazine/components/colors.dart';

class AccountWidget extends StatefulWidget {
  const AccountWidget({super.key});

  @override
  State<AccountWidget> createState() => _AccountWidgetState();
}

Future signOut() async {
  await FirebaseAuth.instance.signOut();
}

class _AccountWidgetState extends State<AccountWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          "${FirebaseAuth.instance.currentUser?.photoURL}",
          height: 120,
          width: 120,
        ),
        FractionallySizedBox(
          widthFactor: 0.8,
          child: Text(
            "Name :  ${FirebaseAuth.instance.currentUser?.displayName}",
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 16,
              color: secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        FractionallySizedBox(
          widthFactor: 0.8,
          child: Text(
            "Email Address :  ${FirebaseAuth.instance.currentUser?.email}",
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: secondary,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: secondary,
              foregroundColor: primary,
              padding: const EdgeInsets.all(10),
            ),
            onPressed: signOut,
            child: const Text("Log Out"))
      ],
    );
  }
}
