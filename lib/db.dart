import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final db = DB.instance.db;

class DB {
  static final instance = DB();
  late Future<Database> db;
  static const tables = [
    'CREATE TABLE modes(id INTEGER PRIMARY KEY , name VARCHAR(255),color VARCHAR(15),icon TEXT);',
    'CREATE TABLE history(id INTEGER PRIMARY KEY , date VARCHAR(10), worked_minutes VARCHAR(3), mode_id INTEGER ,FOREIGN KEY (mode_id) REFERENCES modes(id));',
    'CREATE TABLE tasks(id INTEGER PRIMARY KEY , name TEXT, percent REAL, day UNSIGNED TINYINT ,time_consume UNSIGNED SMALLINT);',
  ];
  Future<Database> openDb() async {
    return openDatabase(
      join(await getDatabasesPath(), 'modes.db'),
      onCreate: (db, version) {
        for (String table in tables) {
          db.execute(table);
        }
      },
      version: 1,
    );
  }

  DB() {
    WidgetsFlutterBinding.ensureInitialized();
    db = openDb();
  }
}
