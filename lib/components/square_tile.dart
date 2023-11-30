import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vartarevarta_magazine/components/colors.dart';
import 'package:vartarevarta_magazine/services/login_service.dart';

class SquareTile extends StatefulWidget {
  const SquareTile({
    super.key,
  });

  @override
  State<SquareTile> createState() => _SquareTileState();
}

class _SquareTileState extends State<SquareTile> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        await AuthServices().signInWithGoogle();
        setState(() {
          isLoading = false;
        });
      },
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
          children: isLoading
              ? [const CircularProgressIndicator()]
              : [
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
