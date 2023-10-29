import 'package:flutter/material.dart';
import 'package:vartarevarta_magazine/components/colors.dart';

class CardWidget extends StatefulWidget {
  final String name;
  final String image;
  final String subtitle;
  final Color background;

  const CardWidget(
      {super.key,
      required this.name,
      required this.image,
      required this.subtitle,
      required this.background});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 4.5,
          ),
          ClipRRect(
              borderRadius: BorderRadius.circular(300),
              child: Image.asset(widget.image, height: 145)),
          Text(
            widget.name,
            style: const TextStyle(
                fontSize: 16, color: cardText, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.subtitle,
            style: const TextStyle(
                fontSize: 12, color: cardText, fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
