import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:kindlelullaby/models/remaindersModel.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String dateTime = 'dateTime';
  static const String selectedApp = 'selectedApp';
  static const String notes = 'notes';
  static const String createdAt = 'createdAt';
  static const String duration = 'duration';
  static const String table = 'remainders';
  static const String dbName = 'remainders.db';

  Future<Database> get db async {
    if(_db != null){
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    String path2 = join(path, dbName);
    print(path2);
    var db = await openDatabase(path2, version: 1, onCreate: _onCreate);
    return db;
  }

  Future _onCreate(Database db, int version) async{
    await db.execute("""CREATE TABLE $table ($ID INTEGER PRIMARY KEY AUTOINCREMENT,
      $selectedApp INTEGER, $notes TEXT, $duration INTEGER, $dateTime TEXT, $createdAt TEXT)
    """);
  }

  Future<Remainder> save(Remainder remainder) async{
    var dbClient = await db;
    print(remainder.toMap());
    remainder.id = await dbClient.insert(table, remainder.toMap());
    return remainder;
  }

  Future<List<Remainder>> getRemainders() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(table, columns: [ID, selectedApp, notes, duration, dateTime, createdAt]);
    List<Remainder> remainders = [];
    if (maps.length > 0) {
      for (int i=0; i< maps.length; i++) {
        remainders.add(Remainder.fromMap(maps[i]));
      }
    }
    return remainders;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(table, where: '$ID = ?', whereArgs:[id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

}

