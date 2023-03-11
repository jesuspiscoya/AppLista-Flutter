import 'package:flutter/material.dart';

class BackgroundDismissible extends StatelessWidget {
  final Color color;
  final Alignment alignment;
  final String texto;

  const BackgroundDismissible(this.color, this.alignment, this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      alignment: alignment,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: color,
      ),
      child: Text(
        texto,
        style:
            const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }
}
