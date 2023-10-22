import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:vartarevarta_magazine/screens/pdf.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class Books {
  final String name;
  final String path;

  Books(this.name, this.path);
}

class _HomeScreenState extends State<HomeScreen> {
  List<Books> array = [];
  buildArray() {
    final storageRef = FirebaseStorage.instance.ref().child('');
    storageRef.listAll().then((result) {
      for (var item in result.items) {
        print(item.name);
        setState(() {
          array.add(Books(item.name, item.fullPath));
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
                    builder: (context) => PdfWidget(path: array[index].path),
                  ),
                );
              },
              title: Text(array[index].name),
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
