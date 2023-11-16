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
  Future<List<CompetitionBook>> buildArray() async {
    late QuerySnapshot snapShot;
    List<CompetitionBook> array = [];
    snapShot = await FirebaseFirestore.instance
        .collection('/competition')
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const FaIcon(FontAwesomeIcons.plus),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CompetitionWidget(),
                ))),
        appBar: AppBar(
          backgroundColor: primary,
          title: const Text("Your Uploads"),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: buildArray(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
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
                          ? Tooltip(
                              message: snapshot.data?[index].status,
                              triggerMode: TooltipTriggerMode.tap,
                              child: const FaIcon(
                                  FontAwesomeIcons.clockRotateLeft),
                            )
                          : snapshot.data?[index].status == "Aprooved"
                              ? Tooltip(
                                  message: snapshot.data?[index].status,
                                  triggerMode: TooltipTriggerMode.tap,
                                  child: const FaIcon(FontAwesomeIcons.check),
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
            } else {
              if (snapshot.hasError) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Some error occured")));
              } else {
                return Center(
                  child: Lottie.asset("assets/anim/loadin.json", width: 190),
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
