import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lista_app/model/articulo.dart';
import 'package:lista_app/services/articulo_dao.dart';
import 'package:lista_app/widgets/listview_build.dart';
import 'package:lista_app/widgets/input_form.dart';

class ArticulosPage extends StatefulWidget {
  const ArticulosPage({super.key});

  @override
  State<ArticulosPage> createState() => _ArticulosPageState();
}

class _ArticulosPageState extends State<ArticulosPage> {
  final GlobalKey<FormState> formArticuloKey = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  GlobalKey<AnimatedListState> listaKey = GlobalKey<AnimatedListState>();
  bool agregar = true, actualizar = false;
  List<Articulo> listaArticulos = <Articulo>[];
  final ArticuloDao articuloDao = ArticuloDao();
  double height = 97;
  late int position;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 800),
      child: Column(
        children: [
          const SizedBox(height: 15),
          textLabel('Nuevo Artículo', 22, Colors.white),
          agregar
              ? buttonMaterial(
                  const Color(0xFF07AA5E),
                  Icons.add_circle_rounded,
                  const Color(0xA0FFFFFF),
                  () {
                    agregar = false;
                    actualizar = false;
                  },
                )
              : buttonMaterial(
                  const Color(0xFFB51A1A),
                  Icons.cancel_rounded,
                  const Color(0xA0FFFFFF),
                  () => limpiarForm(),
                ),
          AnimatedSize(
            duration: const Duration(milliseconds: 450),
            child: SizedBox(
              height: agregar ? 0 : height,
              child: Form(
                key: formArticuloKey,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 8),
                        InputForm(
                            input: 'Nombre', inputController: nombreController),
                        const SizedBox(width: 10),
                        InputForm(
                            input: 'Precio', inputController: precioController),
                        const SizedBox(width: 8)
                      ],
                    ),
                    const SizedBox(height: 10),
                    actualizar ? buttonActualizar() : buttonAgregar(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: listarArticulos()),
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

  Widget buttonMaterial(
      Color? color, IconData icon, Color iconColor, void Function() submit) {
    return MaterialButton(
      minWidth: 0,
      color: color,
      padding: const EdgeInsets.all(4),
      shape: const CircleBorder(),
      child: Icon(icon, size: 22, color: iconColor),
      onPressed: () => setState(() => submit()),
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
    if (formArticuloKey.currentState!.validate()) {
      listaArticulos.add(getArticulo(null));
      articuloDao.insertarArticulo(getArticulo(null));
      listaKey.currentState!
          .insertItem(0, duration: const Duration(milliseconds: 800));
      limpiarForm();
    } else {
      height = 119;
    }
  }

  void submitActualizar() {
    height = 97;
    if (formArticuloKey.currentState!.validate()) {
      articuloDao.modificarArticulo(
          getArticulo(listaArticulos.elementAt(position).codigo));
      listaKey.currentState!
          .removeItem(position, (context, animation) => const SizedBox());
      listaKey.currentState!
          .insertItem(position, duration: const Duration(milliseconds: 800));
      limpiarForm();
    }
  }

  Articulo getArticulo(int? codigo) {
    return Articulo(
      codigo: codigo,
      nombre: nombreController.text,
      precio: double.parse(precioController.text),
    );
  }

  void limpiarForm() {
    agregar = true;
    nombreController.clear();
    precioController.clear();
  }

  Widget listarArticulos() {
    return FutureBuilder(
      future: articuloDao.listarArticulos(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(color: Colors.greenAccent[400]),
          );
        }

        listaArticulos = snapshot.data!;
        return BounceInLeft(
          from: MediaQuery.of(context).size.width,
          duration: const Duration(milliseconds: 600),
          child: AnimatedList(
            key: listaKey,
            initialItemCount: snapshot.data!.length,
            padding: const EdgeInsets.only(top: 5, bottom: 80),
            itemBuilder: (context, index, animation) => ListviewBuild(
                onTap: false, animation: animation, widget: buildWidget(index)),
          ),
        );
      },
    );
  }

  Widget buildWidget(int index) {
    String nombre = listaArticulos.elementAt(index).nombre;
    double precio = listaArticulos.elementAt(index).precio;
    Articulo itemBorrado;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          const SizedBox(width: 5, height: 60),
          buttonMaterial(null, Icons.edit_rounded, Colors.cyanAccent.shade400,
              () {
            position = index;
            agregar = false;
            actualizar = true;
            nombreController.text = nombre;
            precioController.text = precio.toString();
            listaKey.currentState!
                .removeItem(index, (context, animation) => const SizedBox());
            listaKey.currentState!
                .insertItem(index, duration: const Duration(milliseconds: 800));
          }),
          textLabel(nombre, 17, Colors.white),
        ]),
        Row(children: [
          textLabel('S/ $precio', 16, Colors.greenAccent),
          buttonMaterial(null, Icons.delete_rounded, Colors.red, () {
            itemBorrado = listaArticulos.elementAt(index);
            listaArticulos.removeAt(index);
            articuloDao.eliminarArticulo(itemBorrado.codigo!);
            listaKey.currentState!.removeItem(
                index,
                (context, animation) => listaArticulos.isNotEmpty
                    ? ListviewBuild(
                        onTap: false,
                        animation: animation,
                        widget: buildWidget(index))
                    : Container(),
                duration: const Duration(milliseconds: 600));
            showSnackBar(itemBorrado, index);
            FocusScope.of(context).unfocus();
            limpiarForm();
          }),
          const SizedBox(width: 5, height: 60)
        ]),
      ],
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
            articuloDao.insertarArticulo(itemBorrado);
            listaKey.currentState!
                .insertItem(index, duration: const Duration(milliseconds: 800));
          }),
        ),
      ),
    );
  }
}
