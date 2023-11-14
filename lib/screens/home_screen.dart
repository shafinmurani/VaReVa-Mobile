import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vartarevarta_magazine/models/books.dart';
import 'package:vartarevarta_magazine/screens/e_book_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late QuerySnapshot snapShot;
  List<Books> array = [];
  buildArray() async {
    snapShot = await FirebaseFirestore.instance.collection('/magazines').get();

    for (var item in snapShot.docs) {
      setState(() {
        array.add(
          Books(
            name: item["title"],
            path: item["pdfPath"],
            price: int.parse(item["price"]),
            imagePath: item["imagePath"],
            docId: item.reference.id,
            purchasedCount: item["purchased"],
          ),
        );
      });
    }
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
          setState(() {
            array = [];
          });

          await buildArray();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AutoHeightGridView(
            physics: const AlwaysScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            itemCount: array.length,
            builder: (context, index) {
              return GridTile(
                  child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: RouteSettings(
                          name: "Chekcing purchase for ${array[index].name}"),
                      builder: (context) => MoreInfoWidget(
                        item: array[index],
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
                          imageUrl: array[index].imagePath,
                          fit: BoxFit.scaleDown),
                      const Gap(10),
                      Text(
                        array[index].name,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "INR ${array[index].price}",
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ));
            },
          ),
        ),
      );
    } else {
      return Center(
        child: Lottie.asset("assets/anim/loadin.json", width: 190),
      );
    }
  }
}
