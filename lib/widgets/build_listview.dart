import 'package:flutter/material.dart';
import 'package:lista_app/model/lista.dart';
import 'package:lista_app/services/articulo_dao.dart';
import 'package:lista_app/widgets/alertdialog_lista.dart';

class BuildLista extends StatelessWidget {
  final bool onTap;
  final Animation<double> animation;
  final Widget widget;
  final Lista? lista;

  const BuildLista({
    super.key,
    required this.onTap,
    required this.animation,
    required this.widget,
    this.lista,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      ).animate(animation),
      child: GestureDetector(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          elevation: 2,
          color: const Color(0xFF397BFF),
          child: widget,
        ),
        onTap: () => onTap
            ? showDialog(
                context: context,
                builder: (context) => FutureBuilder(
                  future: ArticuloDao().listarArticulos(lista!.codigo!),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                            color: Colors.greenAccent[400]),
                      );
                    }

                    return AlertdialogLista(
                        lista: lista!, listaArticulos: snapshot.data!);
                  },
                ),
              )
            : null,
      ),
    );
  }
}
