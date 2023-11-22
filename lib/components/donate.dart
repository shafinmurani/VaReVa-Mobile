import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vartarevarta_magazine/screens/donation/donation.dart';

class DonateComponent extends StatefulWidget {
  const DonateComponent({super.key});

  @override
  State<DonateComponent> createState() => _DonateComponentState();
}

class _DonateComponentState extends State<DonateComponent> {
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      return ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DonationWidget(),
              ));
        },
        leading: const FaIcon(FontAwesomeIcons.circleDollarToSlot),
        title: const Text("ડોનેશન"),
      );
    } else {
      return const ListTile(
        onTap: null,
        enabled: false,
        leading: FaIcon(FontAwesomeIcons.circleDollarToSlot),
        title: Text("ડોનેશન"),
      );
    }
  }
}
