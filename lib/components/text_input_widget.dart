import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Input extends StatefulWidget {
  final String placeholder;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int minLines;
  final int maxLines;
  final bool enabled;

  const Input({
    super.key,
    required this.placeholder,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.minLines = 1,
    this.maxLines = 2,
    this.enabled = true,
  });

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          enabled: widget.enabled,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.placeholder,
            border: const OutlineInputBorder(),
          ),
        ),
        const Gap(20),
      ],
    );
  }
}
