import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:vartarevarta_magazine/components/colors.dart';
import 'package:vartarevarta_magazine/models/free_read.dart';
import 'package:vartarevarta_magazine/screens/open_library/more_info.dart';

class OpenLibraryList extends StatefulWidget {
  const OpenLibraryList({super.key});

  @override
  State<OpenLibraryList> createState() => _OpenLibraryListState();
}

class _OpenLibraryListState extends State<OpenLibraryList> {
  Future<List<FreeRead>> buildArray(String category) async {
    late QuerySnapshot snapShot;
    List<FreeRead> array = [];
    snapShot = await FirebaseFirestore.instance
        .collection('/open_library')
        .where("category", isEqualTo: category)
        .get();

    for (var item in snapShot.docs) {
      setState(() {
        array.add(
          FreeRead(
            title: item["title"],
            pdf: item["pdfPath"],
            category: item["category"],
            image: item["imagePath"],
            docId: item.reference.id,
            author: item["author"],
            purchased: item["purchased"],
          ),
        );
      });
    }
    return array;
  }

  String dropdownvalue = "";
  bool isData = false;

  Future<List<String>> getCategories() async {
    List<String> items = [];

    await FirebaseFirestore.instance
        .collection("open_lib")
        .doc("categories")
        .get()
        .then((DocumentSnapshot ds) {
      for (var item in ds["list"]) {
        setState(() {
          items.add(item);
        });
      }
    });
    if (dropdownvalue == "") {
      setState(() {
        dropdownvalue = items.first;
        isData = true;
      });
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        centerTitle: true,
        title: const Text("મુક્ત વાંચનાલાય"),
      ),
      body: FutureBuilder(
        future: getCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
              future: buildArray(dropdownvalue),
              builder: (context, arraySnap) {
                if (arraySnap.hasData) {
                  return ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 18),
                        child: DropdownButton(
                          value: dropdownvalue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: snapshot.data!.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AutoHeightGridView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          shrinkWrap: true,
                          itemCount: arraySnap.data!.length,
                          builder: (context, index) {
                            return GridTile(
                                child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MoreInfoWidget(
                                      item: arraySnap.data![index],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                // color: Colors.brown[200],
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                        imageUrl: arraySnap.data![index].image,
                                        fit: BoxFit.scaleDown),
                                    const Gap(10),
                                    Text(
                                      arraySnap.data![index].title,
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "${arraySnap.data?[index].author}",
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ));
                          },
                        ),
                      ),
                    ],
                  );
                } else if (arraySnap.hasError) {
                  return const Center(
                    child: Text("SOME ERROR OCCURED"),
                  );
                }

                return Center(
                  child: Lottie.asset("assets/anim/loadin.json", width: 190),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("SOME ERROR OCCURED"),
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
