import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lista_app/model/lista.dart';
import 'package:lista_app/services/detalle_dao.dart';
import 'package:lista_app/widgets/alertdialog_lista.dart';

class ListviewBuild extends StatelessWidget {
  final bool onTap;
  final Animation<double> animation;
  final Widget widget;
  final Lista? lista;

  const ListviewBuild({
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
      ).animate(CurvedAnimation(parent: animation, curve: Curves.bounceOut)),
      child: GestureDetector(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0, 5),
              colors: <Color>[
                Color(0xFF120F5C),
                Color(0xFF130E9D),
                Color(0xFF420F74),
              ],
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: widget,
        ),
        onTap: () => onTap
            ? showDialog(
                context: context,
                builder: (context) => FutureBuilder(
                  future: DetalleDao().listarDetalle(lista!.codigo!),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                            color: Colors.greenAccent[400]),
                      );
                    }

                    return AlertdialogLista(
                        lista: lista!, listaDetalle: snapshot.data!);
                  },
                ),
              )
            : null,
      ),
    );
  }
}
