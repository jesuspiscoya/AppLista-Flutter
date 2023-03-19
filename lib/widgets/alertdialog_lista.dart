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

class AlertdialogLista extends StatefulWidget {
  final Lista lista;
  final List<Map<Detalle, Articulo>> listaDetalle;

  const AlertdialogLista({
    super.key,
    required this.lista,
    required this.listaDetalle,
  });

  @override
  State<AlertdialogLista> createState() => _AlertdialogListaState();
}

class _AlertdialogListaState extends State<AlertdialogLista> {
  final GlobalKey<FormState> formArticuloKey = GlobalKey<FormState>();
  final GlobalKey<AnimatedListState> listaKey = GlobalKey<AnimatedListState>();
  bool agregar = true, actualizar = false;
  DropdownBuild dropdownArticulo =
      DropdownBuild(search: true, flex: 6, width: 215, height: 390);
  DropdownBuild dropdownUnidad =
      DropdownBuild(search: false, flex: 3, width: 100, height: 195);
  ButtonCantidad buttonCantidad = ButtonCantidad(cantidad: 1);
  late Detalle detalle;
  late Articulo articulo;
  double height = 96;
  late int position;
  final ListaDao listaDao = ListaDao();
  final DetalleDao detalleDao = DetalleDao();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: const Color(0x6E000000),
          body: ZoomIn(
            duration: const Duration(milliseconds: 200),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: GestureDetector(
                onTap: () {},
                child: StatefulBuilder(
                  builder: (context, setState) => AlertDialog(
                    backgroundColor: const Color(0xFF151C4F),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    insetPadding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 85),
                    title: Center(
                        child: textLabel(widget.lista.titulo, 19, Colors.cyan)),
                    titlePadding: const EdgeInsets.symmetric(vertical: 12),
                    contentPadding: EdgeInsets.zero,
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          agregar
                              ? MaterialButton(
                                  minWidth: 0,
                                  padding: const EdgeInsets.all(4),
                                  color: const Color(0xFF07AA5E),
                                  shape: const CircleBorder(),
                                  child: const Icon(
                                    Icons.add_circle_rounded,
                                    size: 22,
                                    color: Color(0xA0FFFFFF),
                                  ),
                                  onPressed: () => setState(() {
                                    agregar = false;
                                    actualizar = false;
                                  }),
                                )
                              : MaterialButton(
                                  minWidth: 0,
                                  padding: const EdgeInsets.all(4),
                                  color: const Color(0xFFB51A1A),
                                  shape: const CircleBorder(),
                                  child: const Icon(
                                    Icons.cancel_rounded,
                                    size: 22,
                                    color: Color(0xA0FFFFFF),
                                  ),
                                  onPressed: () =>
                                      setState(() => limpiarForm()),
                                ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 400),
                            child: SizedBox(
                              height: agregar ? 0 : height,
                              child: Form(
                                key: formArticuloKey,
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 10),
                                        dropdownArticulo,
                                        const SizedBox(width: 8),
                                        dropdownUnidad,
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        buttonCantidad,
                                        const SizedBox(width: 16),
                                        actualizar
                                            ? buttonActualizar()
                                            : buttonAgregar(),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Flexible(child: listarArticulos()),
                          const SizedBox(height: 10),
                          textLabel(
                              'TOTAL: S/ ${getTotal()}', 17, Colors.cyanAccent),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
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
      ),
      child: MaterialButton(
        shape: const StadiumBorder(),
        onPressed: () => setState(() => submitActualizar()),
        child: textLabel('ACTUALIZAR', null, Colors.white),
      ),
    );
  }

  void submitAgregar() {
    height = 118;
    if (formArticuloKey.currentState!.validate()) {
      Detalle newDetalle = Detalle(
          codArticulo: dropdownArticulo.articulo!.codigo!,
          unidad: dropdownUnidad.value!,
          cantidad: buttonCantidad.cantidad);
      Articulo newArticulo = Articulo(
          nombre: dropdownArticulo.articulo!.nombre,
          precio: dropdownArticulo.articulo!.precio);
      widget.listaDetalle.add({newDetalle: newArticulo});
      detalleDao.insertDetalle(widget.lista.codigo!, newDetalle);
      listaDao.modificarLista(getLista());
      listaKey.currentState!.insertItem(widget.listaDetalle.length - 1,
          duration: const Duration(milliseconds: 800));
      limpiarForm();
    }
  }

  void submitActualizar() {
    height = 96;
    if (formArticuloKey.currentState!.validate()) {
      detalle.codArticulo = dropdownArticulo.articulo!.codigo!;
      articulo.nombre = dropdownArticulo.value!;
      detalle.unidad = dropdownUnidad.value!;
      detalle.cantidad = buttonCantidad.cantidad;
      detalleDao.modificarDetalle(detalle);
      listaDao.modificarLista(getLista());
      listaKey.currentState!
          .removeItem(position, (context, animation) => const SizedBox());
      listaKey.currentState!
          .insertItem(position, duration: const Duration(milliseconds: 800));
      limpiarForm();
    }
  }

  Lista getLista() {
    return Lista(
        codigo: widget.lista.codigo,
        titulo: widget.lista.titulo,
        cantidad: widget.listaDetalle.length,
        total: getTotal(),
        estado: 0);
  }

  double getTotal() {
    double total = 0;
    for (var element in widget.listaDetalle) {
      total += element.values.first.precio * element.keys.first.cantidad;
    }
    return total;
  }

  void limpiarForm() {
    agregar = true;
    dropdownArticulo =
        DropdownBuild(search: true, flex: 6, width: 215, height: 390);
    dropdownUnidad =
        DropdownBuild(search: false, flex: 3, width: 100, height: 195);
    buttonCantidad = ButtonCantidad(cantidad: 1);
  }

  Widget listarArticulos() {
    return FlipInY(
      duration: const Duration(milliseconds: 700),
      child: AnimatedList(
        key: listaKey,
        shrinkWrap: true,
        initialItemCount: widget.listaDetalle.length,
        padding: const EdgeInsets.symmetric(vertical: 3),
        itemBuilder: (context, index, animation) => ListviewBuild(
            onTap: false,
            animation: animation,
            widget: dismissible(context, index)),
      ),
    );
  }

  Widget dismissible(BuildContext context, int index) {
    String nombre = widget.listaDetalle.elementAt(index).values.first.nombre;
    double precio = widget.listaDetalle.elementAt(index).values.first.precio;
    String unidad = widget.listaDetalle.elementAt(index).keys.first.unidad;
    int cantidad = widget.listaDetalle.elementAt(index).keys.first.cantidad;
    double monto = precio * cantidad;
    Map<Detalle, Articulo> itemBorrado;

    return Dismissible(
      key: UniqueKey(),
      resizeDuration: const Duration(microseconds: 1),
      background: DismissibleBackground(
          Colors.greenAccent.shade700, Alignment.centerLeft, 'EDITAR'),
      secondaryBackground: const DismissibleBackground(
          Colors.red, Alignment.centerRight, 'ELIMINAR'),
      onDismissed: (direction) => setState(() {
        if (identical(direction, DismissDirection.endToStart)) {
          if (widget.listaDetalle.length > 1) {
            itemBorrado = widget.listaDetalle.elementAt(index);
            widget.listaDetalle.removeAt(index);
            detalleDao.eliminarDetalle(itemBorrado.keys.first.codigo!);
            listaDao.modificarLista(getLista());
            listaKey.currentState!.removeItem(
                index,
                (context, animation) => ListviewBuild(
                    onTap: false,
                    animation: animation,
                    widget: dismissible(context, 0)),
                duration: const Duration(milliseconds: 600));
            showSnackBar(context, itemBorrado, index);
            limpiarForm();
          } else {
            //AlertDialog para confitmar borrar.
          }
        } else {
          position = index;
          agregar = false;
          actualizar = true;
          detalle = widget.listaDetalle.elementAt(index).keys.first;
          articulo = widget.listaDetalle.elementAt(index).values.first;
          dropdownArticulo = DropdownBuild(
              search: true,
              flex: 6,
              width: 215,
              height: 390,
              value: articulo.nombre,
              articulo: articulo);
          dropdownUnidad = DropdownBuild(
              search: false, flex: 3, width: 100, height: 195, value: unidad);
          buttonCantidad = ButtonCantidad(cantidad: cantidad);
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
            child: textLabel(cantidad.toString(), 20, Colors.amber.shade600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textLabel('$unidad $nombre', 17, Colors.white),
                const SizedBox(height: 4),
                textLabel('S/ $precio', 15, Colors.greenAccent.shade400),
              ],
            ),
          ),
          textLabel('S/ $monto', 17, Colors.greenAccent.shade400),
          const SizedBox(width: 15)
        ],
      ),
    );
  }

  void showSnackBar(
      BuildContext context, Map<Detalle, Articulo> itemBorrado, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(itemBorrado.values.first.nombre),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () => setState(() {
            widget.listaDetalle.insert(index, itemBorrado);
            detalleDao.insertDetalle(
                widget.lista.codigo!, itemBorrado.keys.first);
            listaDao.modificarLista(getLista());
            listaKey.currentState!
                .insertItem(index, duration: const Duration(milliseconds: 800));
          }),
        ),
      ),
    );
  }
}
