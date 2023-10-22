import 'package:flutter/material.dart';
import 'package:vartarevarta_magazine/components/colors.dart';
import 'package:vartarevarta_magazine/screens/account.dart';
import 'package:vartarevarta_magazine/screens/home_screen.dart';

class NavigatonBarWidget extends StatefulWidget {
  const NavigatonBarWidget({super.key});

  @override
  State<NavigatonBarWidget> createState() => _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState extends State<NavigatonBarWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    Text(
      'Free Read page',
      style: optionStyle,
    ),
    AccountWidget()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Free Read',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: secondary,
        backgroundColor: primary,
        onTap: _onItemTapped,
      ),
    );
  }
}
