import 'package:sqflite/sqflite.dart';
import 'package:tinda/repositories/database_connection.dart';

class Repository{
  DatabaseConnection _databaseConnection;


  Repository(){
  // initialize database connection
    _databaseConnection = DatabaseConnection();
  }

  static Database _database;

  // Check if database exists or not
  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await _databaseConnection.setDatabse();
    return _database;
  }

  // Insert Data into Table
  inserData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }



}