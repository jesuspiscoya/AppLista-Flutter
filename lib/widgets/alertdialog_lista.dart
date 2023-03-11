import 'package:flutter/material.dart';
import 'package:lista_app/model/articulo.dart';
import 'package:lista_app/model/lista.dart';
import 'package:lista_app/services/articulo_dao.dart';
import 'package:lista_app/services/detalle_dao.dart';
import 'package:lista_app/services/lista_dao.dart';
import 'package:lista_app/widgets/background_dismissible.dart';
import 'package:lista_app/widgets/build_listview.dart';
import 'package:lista_app/widgets/dropdown_unidad.dart';
import 'package:lista_app/widgets/inputs_form.dart';
import 'package:money_input_formatter/money_input_formatter.dart';

class AlertdialogLista extends StatefulWidget {
  final Lista lista;
  final List<Articulo> listaArticulos;

  const AlertdialogLista({
    super.key,
    required this.lista,
    required this.listaArticulos,
  });

  @override
  State<AlertdialogLista> createState() => _AlertdialogListaState();
}

class _AlertdialogListaState extends State<AlertdialogLista> {
  final GlobalKey<FormState> formArticuloKey = GlobalKey<FormState>();
  final GlobalKey<AnimatedListState> listaKey = GlobalKey<AnimatedListState>();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  final ListaDao listaDao = ListaDao();
  final ArticuloDao articuloDao = ArticuloDao();
  final DetalleDao detalleDao = DetalleDao();
  DropdownUnidad dropdownUnidad = DropdownUnidad(itemUnidad: null);
  bool agregar = true, remove = false, actualizar = false;
  int codArticulo = 0;
  late int position;

  @override
  void initState() {
    super.initState();
    getLastCodigo();
  }

  void getLastCodigo() async {
    final data = await articuloDao.lastCodArticulo();
    setState(() {
      codArticulo = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.of(context).pop();
              remove = false;
              agregar = true;
              actualizar = false;
            },
            child: GestureDetector(
              onTap: () {},
              child: StatefulBuilder(
                builder: (context, setState) => AlertDialog(
                  backgroundColor: const Color(0xFF17124A),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  insetPadding: const EdgeInsets.all(20),
                  title: Center(
                      child: textLabel(widget.lista.titulo, 19, Colors.cyan)),
                  titlePadding: const EdgeInsets.only(top: 12),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        agregar
                            ? MaterialButton(
                                minWidth: 30,
                                height: 30,
                                color: const Color(0xFF07AA5E),
                                shape: const CircleBorder(),
                                child: const Icon(
                                  Icons.add_circle_rounded,
                                  size: 22,
                                  color: Color(0xA0FFFFFF),
                                ),
                                onPressed: () => setState(() {
                                  agregar = false;
                                  remove = true;
                                  actualizar = false;
                                  limpiarTexto();
                                }),
                              )
                            : const SizedBox(),
                        remove
                            ? MaterialButton(
                                minWidth: 30,
                                height: 30,
                                color: const Color(0xFFB51A1A),
                                shape: const CircleBorder(),
                                child: const Icon(
                                  Icons.cancel_rounded,
                                  size: 22,
                                  color: Color(0xA0FFFFFF),
                                ),
                                onPressed: () => setState(() {
                                  agregar = true;
                                  remove = false;
                                }),
                              )
                            : const SizedBox(),
                        remove
                            ? Form(
                                key: formArticuloKey,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InputsForm(
                                            margin: const EdgeInsets.only(
                                                left: 8, top: 2, right: 5),
                                            inputController: nombreController,
                                            inputType: TextInputType.name,
                                            hint: 'Nombre',
                                            validator: 'Ingrese nombre.',
                                            inputFormatters: const []),
                                        InputsForm(
                                            margin: const EdgeInsets.only(
                                                left: 5, top: 2, right: 8),
                                            inputController: precioController,
                                            inputType: TextInputType.number,
                                            hint: 'Precio',
                                            validator: 'Ingrese precio.',
                                            inputFormatters: [
                                              MoneyInputFormatter()
                                            ]),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InputsForm(
                                            margin: const EdgeInsets.only(
                                                left: 8, top: 10, right: 5),
                                            inputController: cantidadController,
                                            inputType: TextInputType.number,
                                            hint: 'Cantidad',
                                            validator: 'Ingrese cantidad.',
                                            inputFormatters: const []),
                                        dropdownUnidad
                                      ],
                                    ),
                                    actualizar
                                        ? buttonActualizar()
                                        : buttonAgregar(),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        Flexible(
                          child: listarArticulos(),
                        ),
                        Center(
                          heightFactor: 2.3,
                          child: textLabel('TOTAL: S/ ${getTotal()}', 17,
                              Colors.greenAccent),
                        ),
                      ],
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
      width: 110,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: const StadiumBorder(),
            elevation: 5),
        onPressed: () => setState(() => submitAgregar()),
        child: const Text('AGREGAR'),
      ),
    );
  }

  Widget buttonActualizar() {
    return Container(
      width: 120,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            shape: const StadiumBorder(),
            elevation: 5),
        onPressed: () => setState(() => submitActualizar()),
        child: const Text('ACTUALIZAR'),
      ),
    );
  }

  void submitAgregar() {
    if (formArticuloKey.currentState!.validate()) {
      List<int> listaCodArticulo = <int>[];
      Articulo newArticulo = Articulo(
        nombre: nombreController.text,
        precio: double.parse(precioController.text),
        cantidad: int.parse(cantidadController.text),
        unidad: dropdownUnidad.itemUnidad!,
      );
      widget.listaArticulos.add(newArticulo);
      articuloDao.insertarArticulo(
          widget.listaArticulos.elementAt(widget.listaArticulos.length - 1));
      getLastCodigo();
      listaCodArticulo.add(codArticulo);
      detalleDao.insertDetalle(widget.lista.codigo!, listaCodArticulo);
      listaDao.modificarLista(getLista());
      listaKey.currentState!.insertItem(widget.listaArticulos.length - 1);
      FocusScope.of(context).unfocus();
      limpiarTexto();
    }
  }

  void submitActualizar() {
    if (formArticuloKey.currentState!.validate()) {
      widget.listaArticulos.elementAt(position).nombre = nombreController.text;
      widget.listaArticulos.elementAt(position).precio =
          double.parse(precioController.text);
      widget.listaArticulos.elementAt(position).cantidad =
          int.parse(cantidadController.text);
      widget.listaArticulos.elementAt(position).unidad =
          dropdownUnidad.itemUnidad!;
      articuloDao.modificarArticulo(widget.listaArticulos.elementAt(position));
      listaDao.modificarLista(getLista());
      listaKey.currentState!
          .removeItem(position, (context, animation) => const SizedBox());
      listaKey.currentState!.insertItem(position);
      agregar = true;
      remove = false;
    }
  }

  Lista getLista() {
    return Lista(
        codigo: widget.lista.codigo,
        titulo: widget.lista.titulo,
        cantidad: widget.listaArticulos.length,
        total: getTotal(),
        estado: 0);
  }

  double getTotal() {
    double monto = 0;
    for (var element in widget.listaArticulos) {
      monto += element.precio * element.cantidad;
    }
    return monto;
  }

  void limpiarTexto() {
    nombreController.text = '';
    precioController.text = '';
    cantidadController.text = '';
    dropdownUnidad = DropdownUnidad(itemUnidad: null);
  }

  Widget listarArticulos() {
    return AnimatedList(
      key: listaKey,
      shrinkWrap: true,
      initialItemCount: widget.listaArticulos.length,
      itemBuilder: (context, index, animation) => BuildLista(
        onTap: false,
        animation: animation,
        widget: dismissible(context, index),
      ),
    );
  }

  Widget dismissible(BuildContext context, int index) {
    String nombre = widget.listaArticulos.elementAt(index).nombre;
    double precio = widget.listaArticulos.elementAt(index).precio;
    int cantidad = widget.listaArticulos.elementAt(index).cantidad;
    String unidad = widget.listaArticulos.elementAt(index).unidad;
    Articulo itemBorrado;

    return Dismissible(
      key: UniqueKey(),
      resizeDuration: const Duration(microseconds: 1),
      background: BackgroundDismissible(
          Colors.greenAccent.shade700, Alignment.centerLeft, 'EDITAR'),
      secondaryBackground: const BackgroundDismissible(
          Colors.red, Alignment.centerRight, 'ELIMINAR'),
      onDismissed: (direction) => setState(() {
        if (widget.listaArticulos.length > 1) {
          if (direction == DismissDirection.endToStart) {
            agregar = true;
            remove = false;
            actualizar = false;
            itemBorrado = widget.listaArticulos.elementAt(index);
            widget.listaArticulos.removeAt(index);
            articuloDao.eliminarArticulo(itemBorrado.codigo!);
            listaDao.modificarLista(getLista());
            listaKey.currentState!.removeItem(
              index,
              (context, animation) => BuildLista(
                onTap: false,
                animation: animation,
                widget: dismissible(context, 0),
              ),
            );
            showSnackBar(context, itemBorrado, index);
          } else {
            position = index;
            agregar = false;
            remove = true;
            actualizar = true;
            nombreController.text = nombre;
            precioController.text = precio.toString();
            cantidadController.text = cantidad.toString();
            dropdownUnidad = DropdownUnidad(itemUnidad: unidad);
            listaKey.currentState!
                .removeItem(index, (context, animation) => const SizedBox());
            listaKey.currentState!.insertItem(index);
          }
        } else {
          //AlertDialog para confitmar borrar.
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
                textLabel('$cantidad $unidad $nombre', null, Colors.white),
                const SizedBox(height: 6),
                textLabel('S/ $precio', null, Colors.greenAccent),
              ],
            ),
            textLabel('S/ ${precio * cantidad}', null, Colors.white)
          ],
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, Articulo itemBorrado, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(itemBorrado.nombre),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () => setState(() {
            widget.listaArticulos.insert(index, itemBorrado);
            articuloDao.insertarArticulo(itemBorrado);
            listaDao.modificarLista(getLista());
            listaKey.currentState!.insertItem(index);
          }),
        ),
      ),
    );
  }
}
