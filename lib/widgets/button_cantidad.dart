import 'package:flutter/material.dart';

class ButtonCantidad extends StatefulWidget {
  int cantidad;

  ButtonCantidad({super.key, required this.cantidad});

  @override
  State<ButtonCantidad> createState() => _ButtonCantidadState();
}

class _ButtonCantidadState extends State<ButtonCantidad> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 150,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0xFF12193C)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MaterialButton(
            minWidth: 0,
            padding: const EdgeInsets.all(2),
            shape: const CircleBorder(),
            child: Icon(Icons.remove_circle_rounded,
                size: 25, color: Colors.red.shade700),
            onPressed: () =>
                setState(() => widget.cantidad > 1 ? widget.cantidad-- : null),
          ),
          Text(
            widget.cantidad.toString(),
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          MaterialButton(
            minWidth: 0,
            padding: const EdgeInsets.all(2),
            shape: const CircleBorder(),
            child: Icon(Icons.add_circle_rounded,
                size: 25, color: Colors.greenAccent.shade700),
            onPressed: () =>
                setState(() => widget.cantidad++),
          ),
        ],
      ),
    );
  }
}
