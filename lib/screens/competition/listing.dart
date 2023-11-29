import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:vartarevarta_magazine/components/colors.dart';
import 'package:vartarevarta_magazine/models/competition.dart';
import 'package:vartarevarta_magazine/screens/competition/upload.dart';

class CompetitionListing extends StatefulWidget {
  const CompetitionListing({super.key});

  @override
  State<CompetitionListing> createState() => _CompetitionListingState();
}

class _CompetitionListingState extends State<CompetitionListing> {
  Future buildArray() async {
    return await FirebaseFirestore.instance
        .collection("competition_meta")
        .doc("status")
        .get()
        .then((DocumentSnapshot ds) async {
      if (ds["enabled"]) {
        List? array;
        late QuerySnapshot snapShot;
        snapShot = await FirebaseFirestore.instance
            .collection('/competition')
            .where("uid", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .get();
        if (snapShot.docs.isNotEmpty) {
          array = [];
          for (var item in snapShot.docs) {
            array.add(
              CompetitionBook(
                  address: item['address'],
                  email: item["email"],
                  title: item["title"],
                  pdf: item['pdf'],
                  name: item['name'],
                  phone: item["phone"],
                  status: item["status"],
                  id: item.reference.id),
            );
          }
          return array;
        } else {
          return null;
        }
      }
      return [];
    });
  }

  bool status = false;
  String compName = "";
  getStatus() async {
    // Get Upload count
    await FirebaseFirestore.instance
        .collection("competition")
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      if (value.docs.length == 2) {}
    });

    await FirebaseFirestore.instance
        .collection("competition_meta")
        .doc("status")
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        status = ds["enabled"];
        if (ds["enabled"]) {
          compName = ds["name"];
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: status
            ? FloatingActionButton(
                onPressed: status
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CompetitionWidget(),
                          ),
                        )
                    : null,
                child: const FaIcon(
                  Icons.upload,
                  size: 30,
                ),
              )
            : null,
        appBar: AppBar(
          backgroundColor: primary,
          title: status ? Text(compName) : const Text("Competition"),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: buildArray(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(
                        const Duration(milliseconds: 1200), () {});
                    setState(() {});
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text(
                          "${index + 1}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        title: Text("${snapshot.data?[index].title}"),
                        subtitle: Text("ID : ${snapshot.data?[index].id}"),
                        trailing: snapshot.data?[index].status == "Under Review"
                            ? const Text(
                                "Under Review",
                                style: TextStyle(fontSize: 16),
                              )
                            : snapshot.data?[index].status == "Aprooved"
                                ? const Text(
                                    "Recieved",
                                    style: TextStyle(fontSize: 16),
                                  )
                                : snapshot.data?[index].status == "Declined"
                                    ? const Tooltip(
                                        message: "Declined",
                                        triggerMode: TooltipTriggerMode.tap,
                                        child: FaIcon(FontAwesomeIcons.xmark),
                                      )
                                    : const Tooltip(
                                        message: "Error",
                                        triggerMode: TooltipTriggerMode.tap,
                                        child: FaIcon(
                                            FontAwesomeIcons.circleExclamation),
                                      ),
                      );
                    },
                  ),
                );
              } else if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    "No competitions active right now...",
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "Some error occured",
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset("assets/anim/loadin.json", width: 190),
              );
            } else {
              if (snapshot.data == null) {
                return const Center(
                  child: Text(
                    "No uploads present ",
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
            }
            return Center(
              child: Lottie.asset("assets/anim/loadin.json", width: 190),
            );
          },
        ));
  }
}
