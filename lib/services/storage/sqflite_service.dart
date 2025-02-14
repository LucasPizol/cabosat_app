import 'package:sqflite/sqflite.dart';

class SqfliteService {
  Future<Database> get database async {
    return await openDatabase(
      'database.db',
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE IF NOT EXISTS notification(id TEXT PRIMARY KEY, title TEXT, body TEXT, recievedAt TEXT, isRead TINYINT, isDeleted TINYINT)',
        );

        db.execute(
          'CREATE TABLE IF NOT EXISTS invoice(id TEXT PRIMARY KEY, json TEXT)',
        );

        db.execute(
          'CREATE TABLE IF NOT EXISTS contract(id TEXT PRIMARY KEY, json TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertData(String table, Map<String, dynamic> data) async {
    Database db = await database;
    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getData(String table) async {
    Database db = await database;
    return db.query(table);
  }

  Future<void> updateData(String table, Map<String, dynamic> data) async {
    Database db = await database;

    await db.update(table, data, where: 'id = ?', whereArgs: [data['id']]);
  }

  Future<void> deleteData(String table, String id) async {
    Database db = await database;
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllData(String table) async {
    Database db = await database;
    await db.execute('DELETE FROM $table');
  }

  Future<void> dropTable(String table) async {
    Database db = await database;
    await db.execute('DROP TABLE $table');
  }

  Future<void> dropDatabase() async {
    await deleteDatabase('database.db');
  }
}
