import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const String databaseName = 'YadiraDB.db';
  static const String databaseTable1 = 'articulo';
  static const String databaseTable2 = 'lista';
  static const String databaseTable3 = 'detalle_lista';
  static const int databaseVersion = 1;
  static String sql1 =
      '''CREATE TABLE $databaseTable1(cod_art INTEGER PRIMARY KEY AUTOINCREMENT,
                      nombre TEXT, precio REAL)''';
  static String sql2 =
      '''CREATE TABLE $databaseTable2(cod_list INTEGER PRIMARY KEY AUTOINCREMENT,
                      titulo TEXT, cantidad INTEGER, total REAL, estado INTEGER)''';
  static String sql3 =
      '''CREATE TABLE $databaseTable3(cod_deta_list INTEGER PRIMARY KEY AUTOINCREMENT,
                      cod_list INTEGER, cod_art INTEGER, unidad TEXT, cantidad INTEGER,
                      foreign key(cod_list) references $databaseTable2(cod_list),
                      foreign key(cod_art) references $databaseTable1(cod_art))''';

  static DBHelper instance = DBHelper._init();

  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, databaseName);
    return openDatabase(path, version: databaseVersion, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) async {
    await db.execute(sql1);
    await db.execute(sql2);
    await db.execute(sql3);
  }
}
