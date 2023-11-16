import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vartarevarta_magazine/screens/competition/upload.dart';

class DrawerCompetition extends StatefulWidget {
  final bool buildComp;
  const DrawerCompetition({super.key, required this.buildComp});

  @override
  State<DrawerCompetition> createState() => _DrawerCompetitionState();
}

class _DrawerCompetitionState extends State<DrawerCompetition> {
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      if (widget.buildComp) {
        return ListTile(
          enabled: true,
          onTap: () {
            // signOut();
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CompetitionWidget(),
                ));
          },
          leading: const FaIcon(FontAwesomeIcons.pencil, size: 18),
          title: const Text("Competition"),
        );
      }
      return ListTile(
        enabled: true,
        onTap: () {
          // signOut();
        },
        leading: const FaIcon(FontAwesomeIcons.book, size: 18),
        title: const Text("Open Library"),
      );
      // return Placeholder();
    } else {
      // signed out
      // return const LoginWidget();
      if (widget.buildComp) {
        return const ListTile(
          enabled: false,
          onTap: null,
          leading: FaIcon(FontAwesomeIcons.pencil, size: 18),
          title: Text("Competition"),
        );
      }
      return const ListTile(
        enabled: false,
        onTap: null,
        leading: FaIcon(FontAwesomeIcons.book, size: 18),
        title: Text("Open Library"),
      );
    }
  }
}
