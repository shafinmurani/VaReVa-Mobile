import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:vartarevarta_magazine/components/colors.dart';
import 'package:vartarevarta_magazine/models/free_read.dart';
import 'package:vartarevarta_magazine/screens/books/pdf.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class MoreInfoWidget extends StatefulWidget {
  final FreeRead item;
  const MoreInfoWidget({super.key, required this.item});

  @override
  State<MoreInfoWidget> createState() => _MoreInfoWidgetState();
}

class _MoreInfoWidgetState extends State<MoreInfoWidget> {
  dynamic snapShot;
  bool? s;
  int pageNum = 0;

  getPageNum(String productName) async {
    snapShot = await FirebaseFirestore.instance
        .collection('/data')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    if (snapShot["Read"][productName] != null) {
      setState(() {
        pageNum = snapShot["Read"][productName];
      });
      return true;
    } else {
      setState(() {
        pageNum = 0;
      });
      return false;
    }
  }

  void putRating(double value, String docId) {
    var book = FirebaseFirestore.instance
        .collection("open_library")
        .doc(widget.item.docId);
    book.update({"rating.${FirebaseAuth.instance.currentUser!.uid}": value});
    getRating();
  }

  double rating = 0;
  bool? ratingUploaded;
  double avgRating = 2.5;
  double averageRating = 0;
  double sum = 0;
  List ratingArray = [];
  void getRating() async {
    await FirebaseFirestore.instance
        .collection('open_library')
        .doc(widget.item.docId)
        .get()
        .then((DocumentSnapshot ds) {
      ratingArray = ds["rating"].values.toList();
      if (ratingArray.isNotEmpty) {
        sum = 0;
        for (var e in ratingArray) {
          sum += e;
        }
        setState(() {
          averageRating = sum / ratingArray.length;
        });
      }

      if (ds["rating"][FirebaseAuth.instance.currentUser!.uid] != null) {
        setState(() {
          ratingUploaded = true;
          rating = ds["rating"][FirebaseAuth.instance.currentUser!.uid];
        });
      } else {
        setState(() {
          ratingUploaded = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getRating();
    getPageNum(widget.item.docId);
  }

  Future<File> _fileFromImageUrl() async {
    final response = await http.get(Uri.parse(widget.item.image));

    final documentDirectory = await getApplicationDocumentsDirectory();

    final file = File(join(documentDirectory.path, 'imagetest.png'));

    file.writeAsBytesSync(response.bodyBytes);

    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(widget.item.title),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                _fileFromImageUrl().then((value) {
                  Share.shareXFiles([XFile(value.path)],
                      text:
                          "Check out ${widget.item.title} by ${widget.item.author} at VaReVa Magazine on Play Store\n\n https://play.google.com/store/apps/details?id=co.vareva.magazine ");
                });
              },
              icon: const Icon(
                Icons.share,
                size: 25,
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                const Gap(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 300,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.item.image,
                        ),
                      ),
                    ),
                    Column(children: [
                      Text(
                        widget.item.title,
                        style: const TextStyle(fontSize: 19),
                      ),
                      // const Gap(10),
                      Row(
                        children: [
                          Text(
                            widget.item.author.toString(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ]),
                  ],
                ),
                const Gap(20),
                FractionallySizedBox(
                  widthFactor: 0.85,
                  child: Text(
                    pageNum > 0
                        ? "Continue reading at page ${pageNum - 1}"
                        : pageNum == 0
                            ? "Start Reading..."
                            : "Start Reading...",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ),
                const Gap(10),
                FractionallySizedBox(
                  widthFactor: 0.85,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.download_rounded,
                        size: 18,
                      ),
                      const Gap(2),
                      Text(
                        "${widget.item.purchased}",
                        style: const TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.85,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RatingBar(
                        minRating: 1,
                        initialRating: ratingUploaded == true
                            ? rating
                            : ratingUploaded == false
                                ? averageRating
                                : averageRating.isNaN
                                    ? 0
                                    : 0,
                        ratingWidget: RatingWidget(
                            full: const Icon(
                              Icons.star,
                              color: secondary,
                            ),
                            half: const Icon(
                              Icons.star_half,
                              color: secondary,
                            ),
                            empty: const Icon(
                              Icons.star_border,
                              color: secondary,
                            )),
                        onRatingUpdate: (rating) {
                          // print(rating);
                          putRating(rating, widget.item.docId);
                        },
                        glow: false,
                        allowHalfRating: true,
                        updateOnDrag: false,
                      ),
                      Text(" (${ratingArray.length})"),
                    ],
                  ),
                ),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: secondary,
                      size: 24,
                    ),
                    const Gap(2),
                    Text(
                      averageRating.toStringAsFixed(2),
                      style: const TextStyle(fontSize: 18),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SlideAction(
                outerColor: secondary,
                innerColor: primary,
                text: "Swipe to read",
                onSubmit: () {
                  FirebaseFirestore.instance
                      .collection("open_library")
                      .doc(widget.item.docId)
                      .update({"purchased": FieldValue.increment(1)});
                  // open pdf
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewPDF(
                            pageNum: pageNum,
                            name: widget.item.title,
                            path: widget.item.pdf,
                            id: widget.item.docId),
                      ));
                  return;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
