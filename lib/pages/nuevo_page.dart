import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  DropdownUnidad dropdownUnidad = DropdownUnidad(itemUnidad: null);
  List<Articulo> listaArticulos = <Articulo>[];
  late double monto;
  bool visibleValidacion = false;
  final ArticuloDao articuloDao = ArticuloDao();
  final ListaDao listaDao = ListaDao();
  final DetalleDao detalleDao = DetalleDao();
  bool actualizar = false;
  late int position;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formListaKey,
          child: Row(
            children: [
              InputsForm(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  inputController: tituloController,
                  inputType: TextInputType.text,
                  hint: 'Título',
                  validator: 'Ingrese título.',
                  inputFormatters: const []),
            ],
          ),
        ),
        textLabel('Nuevo Artículo', 22, Colors.white),
        Form(
          key: formArticuloKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputsForm(
                      margin: const EdgeInsets.only(left: 8, top: 12, right: 5),
                      inputController: nombreController,
                      inputType: TextInputType.name,
                      hint: 'Nombre',
                      validator: 'Ingrese nombre.',
                      inputFormatters: const []),
                  InputsForm(
                    margin: const EdgeInsets.only(left: 5, top: 12, right: 8),
                    inputController: precioController,
                    inputType: TextInputType.number,
                    hint: 'Precio',
                    validator: 'Ingrese precio.',
                    inputFormatters: [
                      MoneyInputFormatter(thousandSeparator: ''),
                      LengthLimitingTextInputFormatter(6),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputsForm(
                      margin: const EdgeInsets.only(left: 8, top: 10, right: 5),
                      inputController: cantidadController,
                      inputType: TextInputType.number,
                      hint: 'Cantidad',
                      validator: 'Ingrese cantidad.',
                      inputFormatters: [LengthLimitingTextInputFormatter(3)]),
                  dropdownUnidad
                ],
              ),
              visibleValidacion ? validarLista() : const SizedBox(),
              actualizar ? buttonActualizar() : buttonAgregar(),
            ],
          ),
        ),
        Expanded(child: listarArticulos()),
        listaArticulos.isNotEmpty ? total() : const SizedBox(),
        buttonGuardar(),
      ],
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

  Widget buttonGuardar() {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(bottom: 2),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1697B4),
            shape: const StadiumBorder(),
            elevation: 5),
        onPressed: () => setState(() => submitGuardar()),
        child: const Text('GUARDAR'),
      ),
    );
  }

  void submitAgregar() {
    if (formArticuloKey.currentState!.validate()) {
      visibleValidacion = false;
      Articulo articulo = Articulo(
        nombre: nombreController.text,
        precio: double.parse(precioController.text),
        cantidad: int.parse(cantidadController.text),
        unidad: dropdownUnidad.itemUnidad!,
      );
      listaArticulos.add(articulo);
      listaKey.currentState!.insertItem(listaArticulos.length - 1);
      FocusScope.of(context).unfocus();
      //limpiarTexto();
    }
  }

  void submitActualizar() {
    if (formArticuloKey.currentState!.validate()) {
      actualizar = false;
      listaArticulos.elementAt(position).nombre = nombreController.text;
      listaArticulos.elementAt(position).precio =
          double.parse(precioController.text);
      listaArticulos.elementAt(position).cantidad =
          int.parse(cantidadController.text);
      listaArticulos.elementAt(position).unidad = dropdownUnidad.itemUnidad!;
      listaKey.currentState!
          .removeItem(position, (context, animation) => const SizedBox());
      listaKey.currentState!.insertItem(position);
      FocusScope.of(context).unfocus();
      //limpiarTexto();
    }
  }

  void submitGuardar() {
    List<int> codArticulo = <int>[];
    if (formListaKey.currentState!.validate()) {
      if (listaArticulos.isNotEmpty) {
        visibleValidacion = false;
        actualizar = false;
        for (var element in listaArticulos) {
          articuloDao.insertarArticulo(element);
          articuloDao.lastCodArticulo().then((value) => codArticulo.add(value));
        }
        Lista lista = Lista(
            titulo: tituloController.text,
            cantidad: listaArticulos.length,
            total: monto,
            estado: 0);
        listaDao.insertarLista(lista);
        listaDao
            .lastCodLista()
            .then((value) => detalleDao.insertDetalle(value, codArticulo));
        tituloController.text = '';
        listaArticulos.clear();
        listaKey = GlobalKey<AnimatedListState>();
        limpiarTexto();
        FocusScope.of(context).unfocus();
      } else {
        visibleValidacion = true;
      }
    }
  }

  void limpiarTexto() {
    nombreController.text = '';
    precioController.text = '';
    cantidadController.text = '';
    dropdownUnidad = DropdownUnidad(itemUnidad: null);
  }

  Widget validarLista() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        'Agregar artículos.',
        style: TextStyle(color: Colors.red[600], fontSize: 12),
      ),
    );
  }

  Widget total() {
    monto = 0;
    for (var element in listaArticulos) {
      monto += element.precio * element.cantidad;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 9),
      child: textLabel('TOTAL: S/ $monto', 16, Colors.white),
    );
  }

  Widget listarArticulos() {
    return AnimatedList(
      key: listaKey,
      shrinkWrap: true,
      initialItemCount: listaArticulos.length,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      itemBuilder: (context, index, animation) => BuildLista(
          onTap: false, animation: animation, widget: dismissible(index)),
    );
  }

  Widget dismissible(int index) {
    String nombre = listaArticulos.elementAt(index).nombre;
    double precio = listaArticulos.elementAt(index).precio;
    int cantidad = listaArticulos.elementAt(index).cantidad;
    String unidad = listaArticulos.elementAt(index).unidad;
    Articulo itemBorrado;

    return Dismissible(
      key: UniqueKey(),
      resizeDuration: const Duration(microseconds: 1),
      background: BackgroundDismissible(
          Colors.greenAccent.shade700, Alignment.centerLeft, 'EDITAR'),
      secondaryBackground: const BackgroundDismissible(
          Colors.red, Alignment.centerRight, 'ELIMINAR'),
      onDismissed: (direction) => setState(() {
        if (direction == DismissDirection.endToStart) {
          actualizar = false;
          itemBorrado = listaArticulos.elementAt(index);
          listaArticulos.removeAt(index);
          listaKey.currentState!.removeItem(
            index,
            (context, animation) => listaArticulos.isNotEmpty
                ? BuildLista(
                    onTap: false,
                    animation: animation,
                    widget: dismissible(0),
                  )
                : Container(),
          );
          showSnackBar(itemBorrado, index);
          FocusScope.of(context).unfocus();
        } else {
          position = index;
          actualizar = true;
          nombreController.text = nombre;
          precioController.text = precio.toString();
          cantidadController.text = cantidad.toString();
          dropdownUnidad = DropdownUnidad(itemUnidad: unidad);
          listaKey.currentState!
              .removeItem(index, (context, animation) => const SizedBox());
          listaKey.currentState!.insertItem(index);
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
                const SizedBox(height: 3),
                textLabel('S/ $precio', null, Colors.greenAccent),
              ],
            ),
            textLabel('S/ ${precio * cantidad}', null, Colors.greenAccent),
          ],
        ),
      ),
    );
  }

  void showSnackBar(Articulo itemBorrado, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(itemBorrado.nombre),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () => setState(() {
            listaArticulos.insert(index, itemBorrado);
            listaKey.currentState!.insertItem(index);
          }),
        ),
      ),
    );
  }
}
