import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

//CREATE DATABASE and CREATE TABLE inside the database

class DatabaseConnection{
  setDatabse() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_todolist_sqflite');
    var database = await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);
    return database;
  }

  _onCreatingDatabase(Database database, int version) async {


    //Create Categories Table
    await database.execute("CREATE TABLE categories(id INTEGER PRIMARY KEY, name TEXT, description TEXT)");

    //Create Items Table
    await database.execute("CREATE TABLE items(id INTEGER PRIMARY KEY, createdDate TEXT,  barcode TEXT, name TEXT, quantity INTEGER, category TEXT, buyDate TEXT, supplier TEXT, buyPrice REAL, sellPrice REAL, image TEXT)");


  }

    
}