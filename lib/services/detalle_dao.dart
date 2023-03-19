import 'package:lista_app/model/articulo.dart';
import 'package:lista_app/model/db_helper.dart';
import 'package:lista_app/model/detalle.dart';
import 'package:sqflite/sqflite.dart';

class DetalleDao {
  static const String tabla = DBHelper.databaseTable3;

  Future<void> insertDetalle(int codLista, Detalle detalle) async {
    final Database db = await DBHelper.instance.database;
    detalle.codLista = codLista;
    await db.insert(tabla, detalle.toMap());
  }

  Future<void> modificarDetalle(Detalle detalle) async {
    final Database db = await DBHelper.instance.database;
    await db.update(tabla, detalle.toMap(),
        where: 'cod_deta_list = ?', whereArgs: [detalle.codigo]);
  }

  Future<void> eliminarDetalle(int codigo) async {
    final Database db = await DBHelper.instance.database;
    await db.delete(tabla, where: 'cod_deta_list = ?', whereArgs: [codigo]);
  }

  Future<List<Map<Detalle, Articulo>>> listarDetalle(int codigo) async {
    final Database db = await DBHelper.instance.database;
    const String sql =
        '''SELECT deta.cod_deta_list, list.cod_list, art.cod_art, art.nombre, art.precio,
                  deta.unidad, deta.cantidad
          FROM ${DBHelper.databaseTable1} art
          INNER JOIN $tabla deta ON deta.cod_art = art.cod_art
          INNER JOIN ${DBHelper.databaseTable2} list ON list.cod_list = deta.cod_list
          WHERE list.cod_list = ?''';
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery(sql, [codigo]);
    return queryResult
        .map((e) => {
              Detalle(
                codigo: int.parse(e['cod_deta_list'].toString()),
                codLista: int.parse(e['cod_list'].toString()),
                codArticulo: int.parse(e['cod_art'].toString()),
                unidad: e['unidad'].toString(),
                cantidad: int.parse(e['cantidad'].toString()),
              ): Articulo(
                  codigo: int.parse(e['cod_art'].toString()),
                  nombre: e['nombre'].toString(),
                  precio: double.parse(e['precio'].toString()))
            })
        .toList();
  }
}
