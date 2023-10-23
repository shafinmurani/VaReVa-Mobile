
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:vartarevarta_magazine/screens/payment/check_purchased_status.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class Books {
  final String name;
  final String path;
  final int price;

  Books(this.name, this.path, this.price);
}

class _HomeScreenState extends State<HomeScreen> {
  List<Books> array = [];
  buildArray() {
    final storageRef = FirebaseStorage.instance.ref().child('');
    storageRef.listAll().then((result) {
      for (var item in result.items) {
        setState(() {
          array.add(Books(item.name, item.fullPath, 20));
        });
      }
    });
  }

  @override
  void initState() {
    buildArray();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (array.isNotEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          array = [];
          buildArray();
          await Future.delayed(const Duration(seconds: 2));
        },
        child: ListView.builder(
          itemCount: array.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckPurchased(
                        productId: array[index].name, path: array[index].path),
                  ),
                );
              },
              title: Text(array[index].name),
              trailing: const Text(
                "INR 22.50",
                style: TextStyle(fontSize: 14),
              ),
            );
          },
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
  }
}
