import 'package:lista_app/model/db_helper.dart';
import 'package:lista_app/model/lista.dart';

class ListaDao {
  Future<void> insertLista(Lista lista) async {
    final db = await DBHelper.instance.database;
    await db.insert(DBHelper.databaseTable2, lista.toMap());
  }

  Future<void> modificarLista(Lista lista) async {
    final db = await DBHelper.instance.database;
    await db.update(DBHelper.databaseTable2, lista.toMap(),
        where: 'cod_list = ?', whereArgs: [lista.codigo]);
  }

  Future<void> eliminarLista(int codigo) async {
    final db = await DBHelper.instance.database;
    await db.delete(DBHelper.databaseTable2,
        where: 'cod_list = ?', whereArgs: [codigo]);
  }

  Future<List<Lista>> listarListas(int codigo) async {
    final db = await DBHelper.instance.database;
    const String sql =
        'SELECT * FROM ${DBHelper.databaseTable2} ORDER BY cod_list DESC';
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery(sql, [codigo]);
    return queryResult.map((e) => Lista.fromMap(e)).toList();
  }
}
