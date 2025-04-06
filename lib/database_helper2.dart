import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper2 {
  static final DatabaseHelper2 instance = DatabaseHelper2._privateConstructor();
  static Database? _database;

  DatabaseHelper2._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'sales.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE sales(id INTEGER PRIMARY KEY, customerId INTEGER, carId INTEGER, dealershipId INTEGER, date TEXT)',
        );
        print('Database and table created successfully');
      },
    );
  }

  // Method to fetch all sales
  Future<List<Map<String, dynamic>>> fetchAllSales() async {
    final db = await database;
    return await db.query('sales'); // Query all records from the 'sales' table
  }

  // Method to delete a sale by ID
  Future<int> deleteSale(int id) async {
    final db = await database;
    return await db.delete('sales', where: 'id = ?', whereArgs: [id]);
  }

  // Method to insert a sale into the database
  Future<int> insertSale(Map<String, dynamic> sale) async {
    final db = await database;
    return await db.insert('sales', sale, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
