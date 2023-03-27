import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lista_app/model/lista.dart';
import 'package:lista_app/services/lista_dao.dart';
import 'package:lista_app/widgets/listview_build.dart';

class ListasPage extends StatefulWidget {
  const ListasPage({super.key});

  @override
  State<ListasPage> createState() => _ListasPageState();
}

class _ListasPageState extends State<ListasPage> {
  final GlobalKey<AnimatedListState> listaKey = GlobalKey<AnimatedListState>();
  late String cantidad;

  @override
  Widget build(BuildContext context) {
    return BounceInLeft(
      from: MediaQuery.of(context).size.width,
      duration: const Duration(milliseconds: 600),
      child: FutureBuilder(
        future: ListaDao().listarListas(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: Colors.greenAccent[400]),
            );
          }

          return snapshot.data!.isNotEmpty
              ? AnimatedList(
                  key: listaKey,
                  initialItemCount: snapshot.data!.length,
                  padding: const EdgeInsets.only(top: 5, bottom: 80),
                  itemBuilder: (context, index, animation) => ListviewBuild(
                    onTap: true,
                    animation: animation,
                    widget: listaCard(snapshot.data!.elementAt(index)),
                    lista: snapshot.data!.elementAt(index),
                  ),
                )
              : Center(
                  child: textLabel('Sin información para mostrar.', null,
                      Colors.greenAccent.shade400),
                );
        },
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

  Widget listaCard(Lista lista) {
    lista.cantidad > 1 ? cantidad = 'Artículos' : cantidad = 'Artículo';

    return Row(
      children: [
        const SizedBox(width: 8, height: 56),
        MaterialButton(
            minWidth: 0,
            shape: const CircleBorder(),
            padding: EdgeInsets.zero,
            child: const Icon(Icons.check_circle_outline_rounded,
                color: Colors.greenAccent, size: 40),
            onPressed: () => true),
        const SizedBox(width: 5),
        Expanded(child: textLabel(lista.titulo, 17, Colors.white)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            textLabel('${lista.cantidad} $cantidad', null, Colors.white),
            const SizedBox(height: 4),
            textLabel('Total: S/ ${lista.total}', null, Colors.greenAccent)
          ],
        ),
        const SizedBox(width: 15, height: 56),
      ],
    );
  }
}
