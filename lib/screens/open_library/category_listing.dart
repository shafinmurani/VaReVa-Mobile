import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vartarevarta_magazine/screens/open_library/list.dart';

class OpenLibraryCategoryList extends StatefulWidget {
  const OpenLibraryCategoryList({super.key});

  @override
  State<OpenLibraryCategoryList> createState() =>
      _OpenLibraryCategoryListState();
}

class _OpenLibraryCategoryListState extends State<OpenLibraryCategoryList> {
  Future<List<String>> getCategories() async {
    List<String> items = [];

    await FirebaseFirestore.instance
        .collection("open_lib")
        .doc("categories")
        .get()
        .then((DocumentSnapshot ds) {
      for (var item in ds["list"]) {
          items.add(item);
      }
    });

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {});
      },
      child: FutureBuilder(
        future: getCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OpenLibraryList(
                                      value: snapshot.data![index],
                                    )));
                      },
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text(
                        snapshot.data![index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            );
          }
          return Center(
            child: Lottie.asset("assets/anim/loadin.json", width: 190),
          );
        },
      ),
    );
  }
}
