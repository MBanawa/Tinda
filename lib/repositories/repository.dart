import 'package:sqflite/sqflite.dart';
import 'package:tinda/repositories/database_connection.dart';

class Repository {
  DatabaseConnection _databaseConnection;

  Repository() {
    // initialize database connection
    _databaseConnection = DatabaseConnection();
  }

  static Database _database;

  // Check if database exists or not
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _databaseConnection.setDatabse();
    return _database;
  }

  // Insert Data into Table
  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  // Read data from Table
  readData(table) async {
    var connection = await database;
    return await connection.query(table);
  }

// Read data from Table by ID
  readDataById(table, itemId) async {
    var connection = await database;
    return await connection.query(table, where: 'id=?', whereArgs: [itemId]);
  }
// Update data from Table

  updateData(table, data) async {
    var connection = await database;
    return await connection
        .update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }
// Delete data from Table

  deleteData(table, itemId) async {
    var connection = await database;
    return await connection.rawDelete("DELETE FROM $table WHERE id = $itemId");
  }

  // Read data from table by Column Name
  readDataByColumnName(
      table, columnName, columnValue) async {
    var connection = await database;
    return await connection
        .query(table, where: '$columnName=?', whereArgs: [columnValue]);
  }

}

