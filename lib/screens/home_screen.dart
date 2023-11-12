import 'package:flutter/material.dart';
import 'package:vartarevarta_magazine/screens/payment/check_purchased_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class Books {
  final String name;
  final String path;
  final String imagePath;
  final String docId;
  final int price;

  Books(
      {required this.name,
      required this.path,
      required this.price,
      required this.imagePath,
      required this.docId});
}

class _HomeScreenState extends State<HomeScreen> {
  late QuerySnapshot snapShot;
  List<Books> array = [];
  buildArray() async {
    snapShot = await FirebaseFirestore.instance.collection('/magazines').get();

    for (var item in snapShot.docs) {
      setState(() {
        array.add(Books(
            name: item["title"],
            path: item["pdfPath"],
            price: int.parse(item["price"]),
            imagePath: item["imagePath"],
            docId: item.reference.id));
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
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: AutoHeightGridView(
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
                    builder: (context) => CheckPurchased(
                        productId: array[index].name,
                        path: array[index].path,
                        price: array[index].price,
                        id: array[index].docId),
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
                    Image.network(array[index].imagePath,
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
      );
    } else {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
  }
}
