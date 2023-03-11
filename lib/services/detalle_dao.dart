import 'package:lista_app/model/db_helper.dart';

class DetalleDao {
  Future<void> insertDetalle(int codHistorial, List<int> codArticulo) async {
    final db = await DBHelper.instance.database;

    for (var element in codArticulo) {
      await db.insert(DBHelper.databaseTable3, <String, Object?>{
        'cod_list': codHistorial,
        'cod_art': element,
      });
    }
  }
}
