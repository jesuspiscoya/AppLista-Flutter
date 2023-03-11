import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DropdownUnidad extends StatefulWidget {
  String? itemUnidad;

  DropdownUnidad({super.key, this.itemUnidad});

  @override
  State<DropdownUnidad> createState() => _DropdownUnidadState();
}

class _DropdownUnidadState extends State<DropdownUnidad> {
  List<String> list = <String>['Un', 'Tira', 'Kg', 'Doc', 'Pack'];

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        margin: const EdgeInsets.only(left: 5, top: 10, right: 8),
        child: DropdownButtonFormField2<String>(
          value: widget.itemUnidad,
          style: const TextStyle(color: Colors.white),
          dropdownMaxHeight: 195,
          isDense: true,
          itemHeight: 45,
          itemPadding: const EdgeInsets.only(left: 15),
          buttonPadding: const EdgeInsets.only(left: 6, right: 10),
          scrollbarRadius: const Radius.circular(40),
          scrollbarAlwaysShow: true,
          offset: const Offset(0, -14),
          hint: const Text(
            'Unidad',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF2B2A57),
          ),
          items: list
              .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: const TextStyle(fontSize: 16))))
              .toList(),
          onChanged: (value) => setState(() {
            widget.itemUnidad = value;
          }),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: const Color(0xFF2B2A57),
            contentPadding: const EdgeInsets.symmetric(vertical: 7.8),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          validator: (value) =>
              identical(value, null) ? 'Seleccione  unidad.' : null,
        ),
      ),
    );
  }
}
