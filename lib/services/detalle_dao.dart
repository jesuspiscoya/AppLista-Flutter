import 'package:lista_app/model/db_helper.dart';

class DetalleDao {
  Future<void> insertDetalle(int codHistorial, List<int> codArticulo) async {
    final db = await DBHelper.instance.database;

    await db.insert(DBHelper.databaseTable3, <String, Object?>{
      'cod_hist': codHistorial,
      'cod_art': codHistorial,
    });
  }
}
