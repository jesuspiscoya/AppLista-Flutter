import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:lista_app/model/articulo.dart';
import 'package:lista_app/pages/home_page.dart';
import 'package:lista_app/services/articulo_dao.dart';

class DropdownBuild extends StatefulWidget {
  final bool search;
  final int flex;
  String? value;
  Articulo? articulo;

  DropdownBuild({
    super.key,
    required this.search,
    required this.flex,
    this.value,
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
        isDense: true,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        hint: widget.search
            ? const Text('Articulos', style: TextStyle(color: Colors.grey))
            : const Text('Unidad', style: TextStyle(color: Colors.grey)),
        dropdownStyleData: DropdownStyleData(
            padding: EdgeInsets.zero,
            maxHeight: widget.search ? 285 : 195,
            offset: const Offset(0, -7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF12193d),
            ),
            scrollbarTheme: const ScrollbarThemeData(
                radius: Radius.circular(20),
                thumbVisibility: MaterialStatePropertyAll(true))),
        buttonStyleData: const ButtonStyleData(
            width: 0,
            height: 40,
            padding: EdgeInsetsDirectional.only(start: 12, end: 8)),
        menuItemStyleData: const MenuItemStyleData(height: 45),
        items: lista.isNotEmpty
            ? lista
                .map((e) => DropdownMenuItem<String>(
                    value: widget.search ? e.nombre : e,
                    child: widget.search
                        ? Text(e.nombre, style: const TextStyle(fontSize: 16))
                        : Text(e, style: const TextStyle(fontSize: 16)),
                    onTap: () => widget.search ? widget.articulo = e : null))
                .toList()
            : [
                const DropdownMenuItem<String>(
                    value: '',
                    child: Center(
                        child: Text('Sin artículos para mostrar.',
                            style: TextStyle(fontSize: 15))))
              ],
        selectedItemBuilder: lista.isEmpty
            ? (context) =>
                [const Text('Articulos', style: TextStyle(color: Colors.grey))]
            : null,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: const Color(0xFF12193C),
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0.4, color: Colors.red)),
        ),
        dropdownSearchData: DropdownSearchData(
          searchController: nombreController,
          searchInnerWidgetHeight: widget.search ? 0 : null,
          searchInnerWidget: widget.search
              ? Row(
                  children: [
                    const SizedBox(width: 10, height: 57),
                    Flexible(
                      child: TextFormField(
                        controller: nombreController,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                        decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: const Color(0x1DA2A2A2),
                            contentPadding: const EdgeInsets.all(10),
                            hintText: 'Buscar artículo...',
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8))),
                      ),
                    ),
                    const SizedBox(width: 10, height: 57),
                    InkWell(
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
                            padding: const EdgeInsets.all(4.5),
                            child: Icon(Icons.add_circle_rounded,
                                size: 23, color: Colors.grey.shade400),
                          ),
                        ),
                        onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const HomePage(index: 2)))),
                    const SizedBox(width: 10, height: 57),
                  ],
                )
              : null,
          searchMatchFn: (item, searchValue) =>
              item.value!.toLowerCase().contains(searchValue.toLowerCase()),
        ),
        onMenuStateChange: (isOpen) => isOpen ? nombreController.clear() : null,
        onChanged: (value) => setState(() => widget.value = value),
        validator: (value) => identical(value, null) || identical(value, '')
            ? widget.search
                ? '    Seleccione artículo.'
                : '    Seleccione unidad.'
            : null,
      ),
    );
  }
}
