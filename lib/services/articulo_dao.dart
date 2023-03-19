import 'package:lista_app/model/articulo.dart';
import 'package:lista_app/model/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class ArticuloDao {
  static const String tabla = DBHelper.databaseTable1;

  Future<void> insertarArticulo(Articulo articulo) async {
    final Database db = await DBHelper.instance.database;
    await db.insert(tabla, articulo.toMap());
  }

  Future<void> modificarArticulo(Articulo articulo) async {
    final Database db = await DBHelper.instance.database;
    await db.update(tabla, articulo.toMap(),
        where: 'cod_art = ?', whereArgs: [articulo.codigo]);
  }

  Future<void> eliminarArticulo(int codigo) async {
    final Database db = await DBHelper.instance.database;
    await db.delete(tabla, where: 'cod_art = ?', whereArgs: [codigo]);
  }

  Future<List<Articulo>> listarArticulos() async {
    final Database db = await DBHelper.instance.database;
    final List<Map<String, Object?>> queryResult =
        await db.query(tabla, orderBy: 'cod_art DESC');
    return queryResult.map((e) => Articulo.fromMap(e)).toList();
  }

  /*
  Future<int> lastCodArticulo() async {
    int codigo = 0;
    final db = await DBHelper.instance.database;
    final List<Map<String, Object?>> queryResult = await db.query(tabla,
        columns: ['cod_art'], orderBy: 'cod_art DESC', limit: 1);
    queryResult.first.forEach((key, value) => codigo = value as int);
    return codigo;
  }*/
}
