import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vartarevarta_magazine/components/colors.dart';

class DrawerWrapper extends StatefulWidget {
  const DrawerWrapper({super.key});

  @override
  State<DrawerWrapper> createState() => _DrawerWrapperState();
}

class _DrawerWrapperState extends State<DrawerWrapper> {
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return UserAccountsDrawerHeader(
        decoration: const BoxDecoration(
          color: appBar,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/drawer_background.jpg'),
          ),
        ),
        accountName: Text(
          "${FirebaseAuth.instance.currentUser!.displayName}",
          style: const TextStyle(color: Colors.white),
        ),
        accountEmail: Text(
          "${FirebaseAuth.instance.currentUser!.email}",
          style: const TextStyle(color: Colors.white),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundImage: NetworkImage(
            "${FirebaseAuth.instance.currentUser!.photoURL}",
          ),
        ),
      );
      // return Placeholder();
    } else {
      // signed out
      // return const LoginWidget();
      return const UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          color: appBar,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(
                'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg'),
          ),
        ),
        accountName: Text(
          "Welcome User!",
          style: TextStyle(color: Colors.white),
        ),
        accountEmail: Text(
          "Email Address",
          style: TextStyle(color: Colors.white),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundColor: primary,
          child: Text(
            "U",
            style: TextStyle(
              color: secondary,
              fontSize: 22,
            ),
          ),
        ),
      );
      // return const CircularProgressIndicator.adaptive();
    }
  }
}
