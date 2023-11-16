import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FaIcon(
              FontAwesomeIcons.google,
              color: Colors.teal.shade700,
              size: 22,
            ),
            const SizedBox(
              width: 5.0,
            ),
            const Text('Sign-in with Google')
          ],
        ),
      ),
    );
  }
}
