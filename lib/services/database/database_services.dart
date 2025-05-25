import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

final databaseServicesProvider = Provider((ref) => DatabaseServices());

class DatabaseServices extends ChangeNotifier {
  String dbName = 'sharevoices.db';
  String categoriesTable = 'categories';
  String recordsTable = 'records';
  Database? _db;

  Future<Database> get db async {
    _db ??= await initDb();
    return _db!;
  }

  Future<Database?> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/$dbName';

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    Batch batch = db.batch();

    batch.execute('''
          CREATE TABLE $categoriesTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category_avatar TEXT,
            category_name TEXT
          )
        ''');

    batch.execute('''
          CREATE TABLE $recordsTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category_id INTEGER,
            record_path TEXT,
            record_name TEXT,
            FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE ON UPDATE CASCADE
          )
        ''');

    await batch.commit();

    debugPrint('----------- Database created -----------');
  }

  Future<List<Map<String, Object?>>> readData(String sql) async {
    final appDB = await db;
    return await appDB.rawQuery(sql);
  }

  Future<int> insertData(String sql) async {
    final appDB = await db;
    return await appDB.rawInsert(sql);
  }

  Future<int> updateData(String sql) async {
    final appDB = await db;
    return await appDB.rawUpdate(sql);
  }

  Future<int> deleteData(String sql) async {
    final appDB = await db;
    return await appDB.rawDelete(sql);
  }

  Future dropDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/$dbName';
    await deleteDatabase(path);

    debugPrint('----------- Database deleted -----------');
  }
}
