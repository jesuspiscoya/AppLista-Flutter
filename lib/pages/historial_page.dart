import 'package:flutter/material.dart';
import 'package:lista_app/model/lista.dart';
import 'package:lista_app/services/lista_dao.dart';
import 'package:lista_app/widgets/build_listview.dart';

class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  final GlobalKey<AnimatedListState> listaKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                itemBuilder: (context, index, animation) => BuildLista(
                  onTap: true,
                  animation: animation,
                  widget: listaCard(snapshot.data!.elementAt(index)),
                  lista: snapshot.data!.elementAt(index),
                ),
              )
            : Center(
                child: textCard('Sin información para mostrar.',
                    Colors.greenAccent.shade400),
              );
      },
    );
  }

  Widget listaCard(Lista lista) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textCard(lista.titulo, Colors.white),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              textCard('${lista.cantidad} Artículo', Colors.white),
              const SizedBox(height: 4),
              textCard('Total: S/ ${lista.total}', Colors.greenAccent)
            ],
          )
        ],
      ),
    );
  }

  Widget textCard(String texto, Color color) {
    return Text(texto,
        style: TextStyle(fontWeight: FontWeight.w700, color: color));
  }
}
