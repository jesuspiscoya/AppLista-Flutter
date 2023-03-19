import 'package:lista_app/model/db_helper.dart';
import 'package:lista_app/model/lista.dart';
import 'package:sqflite/sqflite.dart';

class ListaDao {
  static const String tabla = DBHelper.databaseTable2;

  Future<void> insertarLista(Lista lista) async {
    final Database db = await DBHelper.instance.database;
    await db.insert(tabla, lista.toMap());
  }

  Future<void> modificarLista(Lista lista) async {
    final Database db = await DBHelper.instance.database;
    await db.update(tabla, lista.toMap(),
        where: 'cod_list = ?', whereArgs: [lista.codigo]);
  }

  Future<void> eliminarLista(int codigo) async {
    final Database db = await DBHelper.instance.database;
    await db.delete(tabla, where: 'cod_list = ?', whereArgs: [codigo]);
  }

  Future<List<Lista>> listarListas() async {
    final Database db = await DBHelper.instance.database;
    final List<Map<String, Object?>> queryResult =
        await db.query(tabla, orderBy: 'cod_list DESC');
    return queryResult.map((e) => Lista.fromMap(e)).toList();
  }

  Future<int> lastCodLista() async {
    int codigo = 0;
    final Database db = await DBHelper.instance.database;
    final List<Map<String, Object?>> queryResult = await db.query(tabla,
        columns: ['cod_list'], orderBy: 'cod_list DESC', limit: 1);
    queryResult.first.forEach((key, value) {
      codigo = value as int;
    });
    return codigo;
  }
}
