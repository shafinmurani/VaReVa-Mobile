import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vartarevarta_magazine/components/colors.dart';
import 'package:vartarevarta_magazine/screens/competition/listing.dart';
import 'package:vartarevarta_magazine/screens/donation/donation.dart';
import 'package:vartarevarta_magazine/screens/home/home_screen.dart';
import 'package:vartarevarta_magazine/screens/auth/login.dart';
import 'package:vartarevarta_magazine/screens/open_library/category_listing.dart';
import 'package:vartarevarta_magazine/screens/static/about_us.dart';
import 'package:vartarevarta_magazine/screens/subscription/subscribe.dart';
import 'package:vartarevarta_magazine/services/drawer_wrapper.dart';

class WrapperWidget extends StatefulWidget {
  const WrapperWidget({super.key});

  @override
  State<WrapperWidget> createState() => _WrapperWidgetState();
}

class _WrapperWidgetState extends State<WrapperWidget> {
  var _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      setState(() {});
    });
  }

  Future checkAndCreateDocument(String? docID, name, email) async {
    final snapShot =
        await FirebaseFirestore.instance.collection('/data').doc(docID).get();

    var collection = FirebaseFirestore.instance.collection('/data');
    if (!snapShot.exists) {
      // docuement is not exist
      collection
          .doc(docID)
          .set({"Name": name, "Email address": email, "Purchased": []});
    }
  }

  @override
  Widget build(BuildContext context) {
    List<SalomonBottomBarItem> items = [
      /// Home
      SalomonBottomBarItem(
        icon: const Icon(Icons.home),
        title: const Text(
          "હોમ",
          style: TextStyle(fontSize: 15),
        ),
      ),

      /// Open Library
      SalomonBottomBarItem(
        icon: const FaIcon(FontAwesomeIcons.book),
        title: const Text(
          "મુક્ત વાંચનાલાય",
          style: TextStyle(fontSize: 15),
        ),
      ),

      /// Subscribe
      SalomonBottomBarItem(
        icon: const FaIcon(FontAwesomeIcons.indianRupeeSign),
        title: const Text(
          "લવાજમ",
          style: TextStyle(fontSize: 15),
        ),
      ),
    ];

    List<Widget> widgets = [
      const HomeScreen(),
      const OpenLibraryCategoryList(),
      const SubscribeWidget(),
    ];

    List<String> titles = [
      "હોમ",
      "મુક્ત વાંચનાલાય",
      "લવાજમ",
    ];
    if (FirebaseAuth.instance.currentUser != null) {
      // signed in
      checkAndCreateDocument(
        FirebaseAuth.instance.currentUser?.uid,
        FirebaseAuth.instance.currentUser?.displayName,
        FirebaseAuth.instance.currentUser?.email,
      );
      return Scaffold(
        bottomNavigationBar: SalomonBottomBar(
          curve: Curves.decelerate,
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          unselectedItemColor: secondary,
          selectedItemColor: Colors.brown[700],
          // selectedColorOpacity: 0.5,
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: items,
        ),
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Share.shareUri(Uri.parse(
                    "https://play.google.com/store/apps/details?id=co.vareva.magazine"));
              },
              icon: const Icon(Icons.share),
            )
          ],
          backgroundColor: primary,
          centerTitle: true,
          title: Text(titles[_currentIndex]),
        ),
        drawer: Drawer(
            child: ListView(
          children: [
            const DrawerWrapper(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("અમારા વિશે"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutWidget(),
                    ));
              },
            ),
            ListTile(
                leading: const Icon(Icons.currency_rupee_outlined),
                title: const Text("ડોનેશન"),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DonationWidget(),
                      ));
                }),
            const Divider(),
            ListTile(
                leading: const Icon(Icons.book),
                title: const Text("સ્પર્ધા"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CompetitionListing(),
                      ));
                }),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text("Log Out"),
              onTap: () => FirebaseAuth.instance.signOut(),
            ),
          ],
        )),
        body: widgets[_currentIndex],
      );
    } else {
      // signed out
      // return const LoginWidget();
      return Scaffold(
        appBar: AppBar(
          backgroundColor: primary,
          centerTitle: true,
          title: const Text("VaReVa Magazine"),
        ),
        body: const LoginWidget(),
      );
      // return const CircularProgressIndicator.adaptive();
    }
  }
}
