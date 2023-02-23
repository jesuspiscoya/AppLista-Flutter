import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_app/model/articulo.dart';
import 'package:lista_app/services/articulo_dao.dart';
import 'package:money_input_formatter/money_input_formatter.dart';

class NuevoPage extends StatefulWidget {
  const NuevoPage({super.key});

  @override
  State<NuevoPage> createState() => _NuevoPageState();
}

class _NuevoPageState extends State<NuevoPage> {
  TextEditingController tituloController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  TextEditingController cantidadController = TextEditingController();
  GlobalKey<FormState> formListaKey = GlobalKey<FormState>();
  GlobalKey<FormState> formArticuloKey = GlobalKey<FormState>();
  GlobalKey<AnimatedListState> listaKey = GlobalKey<AnimatedListState>();
  List<Articulo> listaArticulo = <Articulo>[];
  String? itemUnidad;
  bool visibleValidacion = false;
  bool visibleTotal = false;
  ArticuloDao articuloDao = ArticuloDao();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formListaKey,
          child: Row(
            children: [
              inputForm(
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  tituloController,
                  TextInputType.text,
                  'Título',
                  'Ingrese título.', [])
            ],
          ),
        ),
        titulo(),
        Form(
          key: formArticuloKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  inputForm(
                      const EdgeInsets.only(left: 8, top: 12, right: 5),
                      nombreController,
                      TextInputType.name,
                      'Nombre',
                      'Ingrese nombre.', []),
                  inputForm(
                      const EdgeInsets.only(left: 5, top: 12, right: 8),
                      precioController,
                      TextInputType.number,
                      'Precio',
                      'Ingrese precio.',
                      [MoneyInputFormatter()]),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  inputForm(
                      const EdgeInsets.only(left: 8, top: 10, right: 5),
                      cantidadController,
                      TextInputType.number,
                      'Cantidad',
                      'Ingrese cantidad.', []),
                  dropDownUnidad(),
                ],
              ),
            ],
          ),
        ),
        visibleValidacion ? validarLista() : Container(),
        buttonAgregar(),
        Expanded(child: listaArticulos()),
        visibleTotal ? total() : Container(),
        buttonGuardar(),
      ],
    );
  }

  Widget inputForm(
      EdgeInsetsGeometry margin,
      TextEditingController inputController,
      TextInputType inputType,
      String hint,
      String validator,
      List<TextInputFormatter> inputFormatters) {
    return Flexible(
      child: Container(
        margin: margin,
        child: TextFormField(
          controller: inputController,
          keyboardType: inputType,
          inputFormatters: inputFormatters,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2B2A57),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            isDense: true,
          ),
          validator: (value) => value!.isEmpty ? validator : null,
        ),
      ),
    );
  }

  Widget titulo() {
    return const Text(
      "Nuevo Artículo",
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget dropDownUnidad() {
    const List<String> list = <String>['Un', 'Tira', 'Kg', 'Doc', 'Pack'];

    return Flexible(
      child: Container(
        margin: const EdgeInsets.only(left: 5, top: 10, right: 8),
        child: DropdownButtonFormField2<String>(
          value: itemUnidad,
          style: const TextStyle(color: Colors.white),
          dropdownMaxHeight: 155,
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
            itemUnidad = value.toString();
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
              identical(value, null) ? 'Seleccione  cantidad.' : null,
        ),
      ),
    );
  }

  Widget buttonAgregar() {
    return Container(
      width: 110,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2554B8),
            shape: const StadiumBorder(),
            elevation: 5),
        onPressed: () => submitArticulo(),
        child: const Text('AGREGAR'),
      ),
    );
  }

  Widget buttonGuardar() {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(bottom: 2),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1697B4),
            shape: const StadiumBorder(),
            elevation: 5),
        onPressed: () => setState(() {
          submitLista();
        }),
        child: const Text('GUARDAR'),
      ),
    );
  }

  void submitArticulo() {
    if (formArticuloKey.currentState!.validate()) {
      visibleTotal = true;
      Articulo articulo = Articulo(
        nombre: nombreController.text,
        precio: double.parse(precioController.text),
        cantidad: int.parse(cantidadController.text),
        unidad: itemUnidad!,
      );
      listaArticulo.add(articulo);
      listaKey.currentState!.insertItem(listaArticulo.length - 1);
    }
  }

  void submitLista() {
    if (formListaKey.currentState!.validate()) {
      if (listaArticulo.isEmpty) {
        visibleValidacion = true;
      } else {
        visibleValidacion = false;
        for (var element in listaArticulo) {
          articuloDao.insertArticulo(element);
        }
      }
    }
  }

  Widget validarLista() {
    return Visibility(
      visible: visibleValidacion,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          'Agregar artículos.',
          style: TextStyle(color: Colors.red[600], fontSize: 12),
        ),
      ),
    );
  }

  Widget total() {
    double monto = 0;
    for (var element in listaArticulo) {
      monto += element.precio * element.cantidad;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 9),
      child: Text(
        'TOTAL: S/ $monto',
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget listaArticulos() {
    return AnimatedList(
      key: listaKey,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      initialItemCount: listaArticulo.length,
      itemBuilder: (context, index, animation) =>
          contenidoLista(index, animation),
    );
  }

  Widget contenidoLista(int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        elevation: 2,
        color: const Color(0xFF397BFF),
        child: dismissible(index),
      ),
    );
  }

  Widget dismissible(int index) {
    String nombre = listaArticulo.elementAt(index).nombre;
    double precio = listaArticulo.elementAt(index).precio;
    int cantidad = listaArticulo.elementAt(index).cantidad;
    String unidad = listaArticulo.elementAt(index).unidad;
    Articulo itemBorrado;

    return Dismissible(
      key: UniqueKey(),
      background: Container(
        padding: const EdgeInsets.only(left: 15),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: const Color(0xFF07AA5E),
        ),
        child: const Text(
          'EDITAR',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      secondaryBackground: Container(
        padding: const EdgeInsets.only(right: 15),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          //image: DecorationImage(image: image),
          borderRadius: BorderRadius.circular(13),
          color: Colors.red,
        ),
        child: const Text(
          'ELIMINAR',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      onDismissed: (direction) => setState(() {
        if (direction == DismissDirection.endToStart) {
          itemBorrado = listaArticulo.elementAt(index);
          listaArticulo.removeAt(index);
          listaKey.currentState!.removeItem(
            index,
            (context, animation) {
              return contenidoLista(index, animation);
            },
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(itemBorrado.nombre),
              action: SnackBarAction(
                label: 'Deshacer',
                onPressed: () => setState(() {
                  listaArticulo.insert(index, itemBorrado);
                  listaKey.currentState!.insertItem(index);
                }),
              ),
            ),
          );
        } else {
          nombreController.text = nombre;
          precioController.text = precio.toString();
          cantidadController.text = cantidad.toString();
          itemUnidad = unidad;
        }
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$cantidad $unidad $nombre',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  'S/ $precio',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.greenAccent),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'S/ ${precio * cantidad}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
