import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lista_app/model/articulo.dart';
import 'package:lista_app/model/detalle.dart';
import 'package:lista_app/model/lista.dart';
import 'package:lista_app/services/detalle_dao.dart';
import 'package:lista_app/services/lista_dao.dart';
import 'package:lista_app/widgets/button_cantidad.dart';
import 'package:lista_app/widgets/dismissible_background.dart';
import 'package:lista_app/widgets/dropdown_build.dart';
import 'package:lista_app/widgets/listview_build.dart';
import 'package:lista_app/widgets/input_form.dart';

class NuevoPage extends StatefulWidget {
  const NuevoPage({super.key});

  @override
  State<NuevoPage> createState() => _NuevoPageState();
}

class _NuevoPageState extends State<NuevoPage> {
  final GlobalKey<FormState> formListaKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formArticuloKey = GlobalKey<FormState>();
  GlobalKey<AnimatedListState> listaKey = GlobalKey<AnimatedListState>();
  final TextEditingController tituloController = TextEditingController();
  DropdownBuild dropdownUnidad =
      DropdownBuild(search: false, flex: 2, width: 145, height: 195);
  DropdownBuild dropdownArticulo =
      DropdownBuild(search: true, flex: 3, width: 223, height: 390);
  List<Map<Detalle, Articulo>> listaArticulos = <Map<Detalle, Articulo>>[];
  bool visibleValidacion = false, actualizar = false;
  ButtonCantidad buttonCantidad = ButtonCantidad(cantidad: 1);
  late int position;
  final DetalleDao detalleDao = DetalleDao();
  final ListaDao listaDao = ListaDao();

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Form(
            key: formListaKey,
            child: Row(children: [
              const SizedBox(width: 8),
              InputForm(input: 'Título', inputController: tituloController),
              const SizedBox(width: 8)
            ]),
          ),
          const SizedBox(height: 10),
          textLabel('Agregar Artículos', 22, Colors.white),
          const SizedBox(height: 10),
          Form(
            key: formArticuloKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 8),
                    dropdownArticulo,
                    const SizedBox(width: 8),
                    dropdownUnidad,
                    const SizedBox(width: 8)
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buttonCantidad,
                    const SizedBox(width: 16),
                    actualizar ? buttonActualizar() : buttonAgregar()
                  ],
                ),
                const SizedBox(height: 10),
                visibleValidacion
                    ? textLabel('Agregar artículos.', 12, Colors.red.shade600)
                    : const SizedBox(),
              ],
            ),
          ),
          Expanded(child: listarArticulos()),
          const SizedBox(height: 9),
          listaArticulos.isNotEmpty
              ? textLabel('TOTAL: S/ ${getTotal()}', 16, Colors.cyanAccent)
              : const SizedBox(),
          const SizedBox(height: 9),
          buttonGuardar(),
          const SizedBox(height: 85),
        ],
      ),
    );
  }

  Widget textLabel(String texto, double? size, Color color) {
    return Text(
      texto,
      style:
          TextStyle(fontSize: size, fontWeight: FontWeight.w700, color: color),
    );
  }

  Widget buttonAgregar() {
    return Container(
      width: 120,
      height: 38,
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
        borderRadius: BorderRadius.all(Radius.circular(30)),
        boxShadow: [BoxShadow(color: Color(0xFFAE31E7), blurRadius: 5)],
      ),
      child: MaterialButton(
        shape: const StadiumBorder(),
        onPressed: () => setState(() => submitAgregar()),
        child: textLabel('AGREGAR', null, Colors.white),
      ),
    );
  }

  Widget buttonActualizar() {
    return Container(
      width: 135,
      height: 38,
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
        borderRadius: BorderRadius.all(Radius.circular(30)),
        boxShadow: [BoxShadow(color: Color(0xFFAE31E7), blurRadius: 5)],
      ),
      child: MaterialButton(
        shape: const StadiumBorder(),
        onPressed: () => setState(() => submitActualizar()),
        child: textLabel('ACTUALIZAR', null, Colors.white),
      ),
    );
  }

  Widget buttonGuardar() {
    return Container(
      width: 140,
      height: 38,
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
        borderRadius: BorderRadius.all(Radius.circular(30)),
        boxShadow: [BoxShadow(color: Color(0xFFAE31E7), blurRadius: 5)],
      ),
      child: MaterialButton(
        shape: const StadiumBorder(),
        onPressed: () => setState(() => submitGuardar()),
        child: textLabel('GUARDAR', null, Colors.white),
      ),
    );
  }

  void submitAgregar() {
    if (formArticuloKey.currentState!.validate()) {
      visibleValidacion = false;
      Detalle detalle = Detalle(
          codArticulo: dropdownArticulo.articulo!.codigo!,
          unidad: dropdownUnidad.value!,
          cantidad: buttonCantidad.cantidad);
      Articulo articulo = Articulo(
          codigo: dropdownArticulo.articulo!.codigo,
          nombre: dropdownArticulo.articulo!.nombre,
          precio: dropdownArticulo.articulo!.precio);
      listaArticulos.add({detalle: articulo});
      listaKey.currentState!.insertItem(listaArticulos.length - 1,
          duration: const Duration(milliseconds: 800));
      //limpiarForm();
    }
  }

  void submitActualizar() {
    if (formArticuloKey.currentState!.validate()) {
      actualizar = false;
      Articulo articulo = listaArticulos.elementAt(position).values.first;
      Detalle detalle = listaArticulos.elementAt(position).keys.first;
      articulo.nombre = dropdownArticulo.value!;
      detalle.unidad = dropdownUnidad.value!;
      detalle.cantidad = buttonCantidad.cantidad;
      listaKey.currentState!
          .removeItem(position, (context, animation) => const SizedBox());
      listaKey.currentState!
          .insertItem(position, duration: const Duration(milliseconds: 800));
      limpiarForm();
    }
  }

  void submitGuardar() {
    if (formListaKey.currentState!.validate()) {
      if (listaArticulos.isNotEmpty) {
        visibleValidacion = false;
        actualizar = false;
        Lista lista = Lista(
            titulo: tituloController.text,
            cantidad: listaArticulos.length,
            total: getTotal(),
            estado: 0);
        listaDao.insertarLista(lista);
        for (var element in listaArticulos) {
          listaDao.lastCodLista().then(
              (value) => detalleDao.insertDetalle(value, element.keys.first));
        }
        tituloController.clear();
        listaArticulos.clear();
        listaKey = GlobalKey<AnimatedListState>();
        limpiarForm();
      } else {
        visibleValidacion = true;
      }
    }
  }

  void limpiarForm() {
    dropdownArticulo =
        DropdownBuild(search: true, flex: 3, width: 223, height: 390);
    dropdownUnidad =
        DropdownBuild(search: false, flex: 2, width: 145, height: 195);
    buttonCantidad = ButtonCantidad(cantidad: 1);
  }

  double getTotal() {
    double total = 0;
    for (var element in listaArticulos) {
      total += element.values.first.precio * element.keys.first.cantidad;
    }
    return total;
  }

  Widget listarArticulos() {
    return AnimatedList(
      key: listaKey,
      shrinkWrap: true,
      initialItemCount: listaArticulos.length,
      padding: const EdgeInsets.symmetric(vertical: 3),
      itemBuilder: (context, index, animation) => ListviewBuild(
          onTap: false, animation: animation, widget: dismissible(index)),
    );
  }

  Widget dismissible(int index) {
    Articulo articulo = listaArticulos.elementAt(index).values.first;
    Detalle detalle = listaArticulos.elementAt(index).keys.first;
    String nombre = articulo.nombre;
    double precio = articulo.precio;
    String unidad = detalle.unidad;
    double monto = precio * detalle.cantidad;
    Map<Detalle, Articulo> itemBorrado;

    return Dismissible(
      key: UniqueKey(),
      resizeDuration: const Duration(microseconds: 1),
      background: DismissibleBackground(
          Colors.greenAccent.shade700, Alignment.centerLeft, 'EDITAR'),
      secondaryBackground: const DismissibleBackground(
          Colors.red, Alignment.centerRight, 'ELIMINAR'),
      onDismissed: (direction) => setState(() {
        if (direction == DismissDirection.endToStart) {
          actualizar = false;
          itemBorrado = listaArticulos.elementAt(index);
          listaArticulos.removeAt(index);
          listaKey.currentState!.removeItem(
              index,
              (context, animation) => listaArticulos.isNotEmpty
                  ? ListviewBuild(
                      onTap: false,
                      animation: animation,
                      widget: dismissible(0))
                  : Container(),
              duration: const Duration(milliseconds: 600));
          limpiarForm();
          showSnackBar(itemBorrado, index);
          FocusScope.of(context).unfocus();
        } else {
          position = index;
          actualizar = true;
          dropdownArticulo = DropdownBuild(
              search: true,
              flex: 3,
              width: 223,
              height: 390,
              value: articulo.nombre);
          dropdownUnidad = DropdownBuild(
              search: false, flex: 2, width: 145, height: 195, value: unidad);
          buttonCantidad = ButtonCantidad(cantidad: detalle.cantidad);
          listaKey.currentState!
              .removeItem(index, (context, animation) => const SizedBox());
          listaKey.currentState!
              .insertItem(index, duration: const Duration(milliseconds: 800));
        }
      }),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 15, top: 17, right: 18, bottom: 17),
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.bottomLeft,
                radius: 1.8,
                colors: <Color>[
                  Color(0xFF120F5C),
                  Color(0xFF130E9D),
                  Color(0xFF420F74),
                ],
              ),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(30)),
            ),
            child: textLabel(
                detalle.cantidad.toString(), 20, Colors.amber.shade600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textLabel('$unidad $nombre', 16, Colors.white),
                const SizedBox(height: 4),
                textLabel('S/ $precio', 16, Colors.greenAccent.shade400),
              ],
            ),
          ),
          textLabel('S/ $monto', 17, Colors.greenAccent.shade400),
          const SizedBox(width: 15)
        ],
      ),
    );
  }

  void showSnackBar(Map<Detalle, Articulo> itemBorrado, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(itemBorrado.values.first.nombre),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () => setState(() {
            listaArticulos.insert(index, itemBorrado);
            listaKey.currentState!
                .insertItem(index, duration: const Duration(milliseconds: 800));
          }),
        ),
      ),
    );
  }
}
