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
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: cardColot,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: cardColot.withOpacity(0.8),
              blurRadius: 2,
              spreadRadius: 2,
              offset: const Offset(4, 10), // Shadow position
            ),
          ],
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
      ),
    );
  }
}
