import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper1 {
  static final DatabaseHelper1 instance = DatabaseHelper1._privateConstructor();
  static Database? _database;

  DatabaseHelper1._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'car_dealership.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE dealerships (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            address TEXT NOT NULL,
            city TEXT NOT NULL,
            postalCode TEXT NOT NULL
          )
          ''',
        );
        print('Car Dealership Database and Table Created Successfully');
      },
    );
  }

  // Fetch all dealerships
  Future<List<Map<String, dynamic>>> fetchAllDealerships() async {
    final db = await database;
    return await db.query('dealerships');
  }

  // Insert a dealership
  Future<int> insertDealership(Map<String, dynamic> dealership) async {
    final db = await database;
    return await db.insert('dealerships', dealership);
  }

  // Update a dealership
  Future<int> updateDealership(Map<String, dynamic> dealership) async {
    final db = await database;
    return await db.update(
      'dealerships',
      dealership,
      where: 'id = ?',
      whereArgs: [dealership['id']],
    );
  }

  // Delete a dealership
  Future<int> deleteDealership(int id) async {
    final db = await database;
    return await db.delete('dealerships', where: 'id = ?', whereArgs: [id]);
  }
}
