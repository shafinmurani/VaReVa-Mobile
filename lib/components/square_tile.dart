import 'package:flutter/material.dart';
import 'package:vartarevarta_magazine/components/colors.dart';

class SquareTile extends StatelessWidget {
  final void Function()? ontap;
  const SquareTile({super.key, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        backgroundColor: secondary,
        foregroundColor: primary,
        padding: const EdgeInsets.all(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'assets/google_logo.png',
            fit: BoxFit.cover,
            height: 40,
            width: 40,
          ),
          const SizedBox(
            width: 5.0,
          ),
          const Text('Sign-in with Google')
        ],
      ),
    );
  }
}
