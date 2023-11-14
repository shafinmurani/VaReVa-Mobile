import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:vartarevarta_magazine/components/colors.dart';
import 'package:vartarevarta_magazine/models/books.dart';
import 'package:vartarevarta_magazine/screens/payment/payment_gateway.dart';
import 'package:vartarevarta_magazine/screens/pdf.dart';

class MoreInfoWidget extends StatefulWidget {
  final Books item;
  const MoreInfoWidget({super.key, required this.item});

  @override
  State<MoreInfoWidget> createState() => _MoreInfoWidgetState();
}

class _MoreInfoWidgetState extends State<MoreInfoWidget> {
  dynamic snapShot;
  bool? s;
  int pageNum = 0;
  getData(String? docId, String productId) async {
    snapShot = await FirebaseFirestore.instance
        .collection('/data')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    if (snapShot["Purchased"].contains(productId)) {
      setState(() {
        s = true;
      });
    } else {
      setState(() {
        s = false;
      });
    }
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

    if (s == true) {
      await getPageNum(widget.item.docId);
    }
  }

  @override
  void initState() {
    super.initState();
    getData(FirebaseAuth.instance.currentUser?.uid, widget.item.docId);
  }

  @override
  Widget build(BuildContext context) {
    if (s != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: primary,
          title: Text(widget.item.name),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                    child: Image.network(
                      widget.item.imagePath,
                    ),
                  ),
                ),
                Column(children: [
                  Text(
                    widget.item.name,
                    style: const TextStyle(fontSize: 19),
                  ),
                  // const Gap(10),
                  Row(
                    children: [
                      const Icon(Icons.currency_rupee, size: 18, weight: 2),
                      Text(
                        widget.item.price.toString(),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
                    "${widget.item.purchasedCount}",
                    style: const TextStyle(fontSize: 14),
                  )
                ],
              ),
            ),
            const Expanded(child: Gap(0)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SlideAction(
                  outerColor: secondary,
                  innerColor: primary,
                  text: s == true
                      ? "Read"
                      : s == false
                          ? "Purchase"
                          : "Loading...",
                  onSubmit: () {
                    if (s == true) {
                      // open pdf
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewPDF(
                                pageNum: pageNum,
                                name: widget.item.name,
                                path: widget.item.path,
                                id: widget.item.docId),
                          ));
                      return;
                    } else if (s == false) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentWidget(
                                page: pageNum,
                                productName: widget.item.name,
                                path: widget.item.path,
                                price: widget.item.price,
                                id: widget.item.docId),
                          ));
                      return;
                      // Open purchase page
                    }
                    return;
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Loading..."),
        backgroundColor: primary,
      ),
      body: const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
