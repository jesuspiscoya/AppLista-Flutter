import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:lista_app/model/articulo.dart';
import 'package:lista_app/services/articulo_dao.dart';

class DropdownBuild extends StatefulWidget {
  final bool search;
  late int flex;
  String? value;
  final double width;
  final double height;
  late Articulo? articulo;

  DropdownBuild({
    super.key,
    required this.search,
    required this.flex,
    this.value,
    required this.width,
    required this.height,
    this.articulo,
  });

  @override
  State<DropdownBuild> createState() => _DropdownBuildState();
}

class _DropdownBuildState extends State<DropdownBuild> {
  List<dynamic> lista = <dynamic>[];

  @override
  void initState() {
    super.initState();
    widget.search
        ? getArticulos()
        : lista = ['Un', 'Kg', 'Doc', 'Tira', 'Pack'];
  }

  void getArticulos() async {
    final data = await ArticuloDao().listarArticulos();
    setState(() {
      lista = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nombreController = TextEditingController();

    return Flexible(
      flex: widget.flex,
      child: DropdownButtonFormField2<String>(
        value: widget.value,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        hint: widget.search
            ? const Text('Articulos', style: TextStyle(color: Colors.grey))
            : const Text('Unidad', style: TextStyle(color: Colors.grey)),
        dropdownMaxHeight: widget.height,
        dropdownWidth: widget.width,
        isDense: true,
        itemHeight: 45,
        scrollbarRadius: const Radius.circular(40),
        scrollbarAlwaysShow: true,
        offset: const Offset(-12, -15),
        items: lista
            .map(
              (e) => DropdownMenuItem<String>(
                value: widget.search ? e.nombre : e,
                child: widget.search
                    ? Text(e.nombre, style: const TextStyle(fontSize: 16))
                    : Text(e, style: const TextStyle(fontSize: 16)),
                onTap: () => widget.search ? widget.articulo = e : null,
              ),
            )
            .toList(),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFF12193C),
        ),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: const Color(0xFF12193C),
          contentPadding: const EdgeInsets.only(
              left: 12, top: 7.8, bottom: 7.8, right: 8),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0.4, color: Colors.red)),
        ),
        searchController: nombreController,
        searchInnerWidgetHeight: widget.search ? 50 : null,
        searchInnerWidget: widget.search
            ? Flexible(
                child: Container(
                  height: 55,
                  padding: const EdgeInsets.only(
                      top: 12, bottom: 4, right: 12, left: 12),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          expands: true,
                          maxLines: null,
                          controller: nombreController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText: 'Buscar artículo',
                              hintStyle: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.white))),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          child: Ink(
                            decoration: const BoxDecoration(
                                gradient: RadialGradient(
                                  center: Alignment.bottomLeft,
                                  radius: 3.5,
                                  colors: <Color>[
                                    Color(0xFFAE31E7),
                                    Color(0xFF204BFC),
                                    Color(0xFF0190F9),
                                  ],
                                ),
                                shape: BoxShape.circle),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              child: const Icon(
                                Icons.add_circle_rounded,
                                size: 22,
                                color: Color(0xA0FFFFFF),
                              ),
                            ),
                          ),
                          onTap: () => setState(() => true),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : null,
        searchMatchFn: (item, searchValue) =>
            item.value.toLowerCase().contains(searchValue.toLowerCase()),
        onMenuStateChange: (isOpen) =>
            isOpen ? nombreController.clear() : null,
        onChanged: (value) => setState(() => widget.value = value),
        validator: (value) => identical(value, null)
            ? widget.search
                ? 'Seleccione artículo.'
                : 'Seleccione unidad.'
            : null,
      ),
    );
  }
}
