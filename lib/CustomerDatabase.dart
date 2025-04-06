import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'Customer.dart';
import 'CustomerDAO.dart';

part 'CustomerDatabase.g.dart';

@Database(version: 1, entities: [Customer])
abstract class CustomerDatabase extends FloorDatabase {
  CustomerDAO get customerDAO;
}
