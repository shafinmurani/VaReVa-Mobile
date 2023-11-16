import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessFulWidget extends StatefulWidget {
  const SuccessFulWidget({super.key});

  @override
  State<SuccessFulWidget> createState() => _SuccessFulWidgetState();
}

class _SuccessFulWidgetState extends State<SuccessFulWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController lottieController;
  @override
  void initState() {
    super.initState();
    lottieController = AnimationController(
      vsync: this,
    );

    lottieController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Timer(const Duration(seconds: 2), () {});
        Navigator.pop(context);
        lottieController.reset();
      }
    });
  }

  @override
  void dispose() {
    lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Lottie.asset(
        "assets/anim/successful_lottie.json",
        controller: lottieController,
        onLoaded: (composition) {
          lottieController.duration = composition.duration;
          lottieController.forward();
        },
        repeat: false,
      )),
    );
  }
}
