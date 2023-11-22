import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vartarevarta_magazine/screens/subscription/subscribe.dart';

class SubscribeComponent extends StatefulWidget {
  const SubscribeComponent({super.key});

  @override
  State<SubscribeComponent> createState() => _SubscribeComponentState();
}

class _SubscribeComponentState extends State<SubscribeComponent> {
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      return ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SubscribeWidget(),
              ));
        },
        leading: const FaIcon(FontAwesomeIcons.indianRupeeSign),
        title: const Text("લવાજમ ભરવા માટે"),
      );
    } else {
      return const ListTile(
        onTap: null,
        enabled: false,
        leading: FaIcon(FontAwesomeIcons.indianRupeeSign),
        title: Text("લવાજમ ભરવા માટે"),
      );
    }
  }
}
