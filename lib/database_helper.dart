import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'car_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTable,
    );
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
    CREATE TABLE cars (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      brand TEXT,
      model TEXT,
      passengers INTEGER,
      fuelCapacity REAL  -- Corrected column name
    )
  ''');
  }


  Future<int> insertCar(Map<String, dynamic> car) async {
    final db = await database;
    return await db.insert('cars', car);
  }

  Future<List<Map<String, dynamic>>> getCars() async {
    final db = await database;
    return await db.query('cars', orderBy: 'id DESC');
  }

  Future<int> updateCar(Map<String, dynamic> car, int id) async {
    final db = await database;
    return await db.update('cars', car, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteCar(int id) async {
    final db = await database;
    return await db.delete('cars', where: 'id = ?', whereArgs: [id]);
  }
}
