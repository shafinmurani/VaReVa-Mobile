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
  final String value;
  const OpenLibraryList({super.key, required this.value});

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
    }

    return array;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.value),
        backgroundColor: primary,
      ),
      body: FutureBuilder(
        future: buildArray(widget.value),
        builder: (context, arraySnap) {
          if (arraySnap.hasData) {
            return ListView(
              children: [
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      ),
    );
  }
}
