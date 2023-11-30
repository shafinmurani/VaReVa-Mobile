import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:vartarevarta_magazine/components/square_tile.dart';
import 'package:vartarevarta_magazine/screens/auth/privacy_policy/privacy.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/anim/login.json"),
            const Gap(10),
            const SquareTile(
            ),
            const Gap(40),
            const Text("By logging in you agree to our data privacy policy."),
            const Gap(10),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicy(),
                    ));
              },
              child: const Text("Open Privacy policy"),
            )
          ],
        ),
      ),
    );
  }
}
