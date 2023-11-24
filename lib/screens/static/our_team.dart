import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:vartarevarta_magazine/components/card.dart';
import 'package:vartarevarta_magazine/components/colors.dart';

class OurTeamWidget extends StatelessWidget {
  const OurTeamWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> array = [
      const CardWidget(
          name: "Chhaya Upadhyay",
          image: "assets/team_image/chhaya_upadhyay.jpg",
          subtitle: "Editor",
          background: cardColot),
      const CardWidget(
          name: "Narendrasinh Rana",
          image: "assets/team_image/narendrasinh_rana.jpeg",
          subtitle: "Editor",
          background: cardColot),
      const CardWidget(
          name: "Rajul Bhanushali",
          image: "assets/team_image/rajul_bhanushali.jpeg",
          subtitle: "Editor",
          background: cardColot),
      const CardWidget(
          name: "Niraj Kansara",
          image: "assets/team_image/niraj_kansara.jpeg",
          subtitle: "Editor",
          background: cardColot),
      const CardWidget(
          name: "Nilesh Murani",
          image: "assets/team_image/nilesh_murani.jpeg",
          subtitle: "Editor",
          background: cardColot),
    ];
    List<Widget> eMagazineArray = [
      const CardWidget(
          name: "Shafin Murani",
          image: "assets/team_image/shafin_murani.jpg",
          subtitle: "Developer | IT Team",
          background: cardColot),
      const CardWidget(
          name: "Shivani Desai",
          image: "assets/team_image/shivani_desai.jpg",
          subtitle: "Web Content Editor",
          background: cardColot),
      const CardWidget(
          name: "Shraddha Bhatt",
          image: "assets/team_image/shraddha_bhatt.jpg",
          subtitle: "Web Content Editor",
          background: cardColot),
      const CardWidget(
          name: "Sanjay Upadhyay",
          image: "assets/team_image/sanjay_upadhyay.jpg",
          subtitle: "Web Content Editor",
          background: cardColot),
      const CardWidget(
          name: "Ekta Doshi",
          image: "assets/team_image/ekta_doshi.jpeg",
          subtitle: "Web Content Editor",
          background: cardColot),
    ];
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: appBar,
            centerTitle: true,
            title: const Text("વારેવા ટોળી"),
            bottom: const TabBar(tabs: [
              Tab(
                icon: Icon(Icons.library_books_outlined),
                text: "Magazine Team",
              ),
              Tab(
                icon: Icon(Icons.phone_android_outlined),
                text: "E-Magazine Team",
              )
            ]),
          ),
          body: TabBarView(children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: AutoHeightGridView(
                  crossAxisCount: 2,
                  itemCount: array.length,
                  physics: const ScrollPhysics(
                      parent: BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.normal)),
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 20,
                  builder: (context, index) {
                    return array[index];
                  },
                )),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: AutoHeightGridView(
                  itemCount: eMagazineArray.length,
                  crossAxisCount: 2,
                  physics: const ScrollPhysics(
                      parent: BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.normal)),
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 20,
                  builder: (context, index) {
                    return eMagazineArray[index];
                  },
                )),
          ])),
    );
  }
}
