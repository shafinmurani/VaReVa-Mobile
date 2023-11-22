import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vartarevarta_magazine/components/colors.dart';

class SubscribeWidget extends StatefulWidget {
  const SubscribeWidget({super.key});

  @override
  State<SubscribeWidget> createState() => _SubscribeWidgetState();
}

class _SubscribeWidgetState extends State<SubscribeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("લવાજમ ભરવા માટે"),
        centerTitle: true,
        backgroundColor: primary,
      ),
      body: Center(
          child: Column(
        children: [
          Center(
            child: Lottie.asset("assets/anim/loadin.json", width: 190),
          ),
          const Text("UNDER CONSTRUCTION")
        ],
      )),
    );
  }
}
