import 'package:lista_app/model/articulo.dart';
import 'package:lista_app/model/db_helper.dart';

class ArticuloDao {
  Future<void> insertarArticulo(Articulo articulo) async {
    final db = await DBHelper.instance.database;
    await db.insert(DBHelper.databaseTable1, articulo.toMap());
  }

  Future<void> modificarArticulo(Articulo articulo) async {
    final db = await DBHelper.instance.database;
    await db.update(DBHelper.databaseTable1, articulo.toMap(),
        where: 'cod_art = ?', whereArgs: [articulo.codigo]);
  }

  Future<void> eliminarArticulo(int codigo) async {
    final db = await DBHelper.instance.database;
    await db.delete(DBHelper.databaseTable1,
        where: 'cod_art = ?', whereArgs: [codigo]);
  }

  Future<List<Articulo>> listarArticulos(int codigo) async {
    final db = await DBHelper.instance.database;
    const String sql =
        '''SELECT art.cod_art, art.nombre, art.precio, art.cantidad, art.unidad FROM ${DBHelper.databaseTable1} art
        INNER JOIN ${DBHelper.databaseTable3} deta ON deta.cod_art = art.cod_art
        INNER JOIN ${DBHelper.databaseTable2} list ON list.cod_list = deta.cod_list
        WHERE list.cod_list = ?''';
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery(sql, [codigo]);
    return queryResult.map((e) => Articulo.fromMap(e)).toList();
  }

  Future<int> lastCodArticulo() async {
    int codigo = 0;
    final db = await DBHelper.instance.database;
    final List<Map<String, Object?>> queryResult = await db.query(
        DBHelper.databaseTable1,
        columns: ['cod_art'],
        orderBy: 'cod_art DESC',
        limit: 1);
    queryResult.first.forEach((key, value) {
      codigo = value as int;
    });
    return codigo;
  }
}
