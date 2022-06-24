import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';
import 'Provider/plant.dart';

class SQLHelper {
  var _db;

  Future<Database> get database async {
    print('접속');
    // if (_db != null) return _db;
    // _db = openDatabase(join(await getDatabasesPath(), 'singmul-won.db'),
    //     onCreate: (db, version) => _createDb(db), version: 1);
    // return _db;
    final databasePath = await sql.getDatabasesPath();
    String path = join(databasePath, 'singmul-won.db');

    _db = await sql.openDatabase(
      path,
      version: 1,
      onConfigure: (Database db) => {},
      onCreate: (Database db, int version) {
        return _createDb;
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) => {},
    );
    return _db;
  }

  static void _createDb(Database db) {
    db.execute(
      "CREATE TABLE Plant(id TEXT PRIMARY KEY, name TEXT,sort TEXT,image TEXT,water REAL,light REAL,favorite REAL, isFavorite INTEGER)",
    );
  }

  Future<void> insertPlant(Plant plant) async {
    final db = await database;

    await db.insert("Plant", plant.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Plant>> getAllPlant() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('Plant');

    return List.generate(maps.length, (i) {
      return Plant(
          id: maps[i]['id'],
          name: maps[i]['name'],
          sort: maps[i]['sort'],
          image: maps[i]['image'],
          water: maps[i]['water'],
          light: maps[i]['light'],
          favorite: maps[i]['favorite']);
    });
  }

  Future<dynamic> getPlant(String id) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = (await db.query(
      'Plant',
      where: 'id = ?',
      whereArgs: [id],
    ));

    return maps.isNotEmpty ? maps : null;
  }

  Future<void> updatePlant(Plant plant) async {
    final db = await database;

    await db.update(
      "Plant",
      plant.toMap(),
      where: "id = ?",
      whereArgs: [plant.id],
    );
  }

  Future<void> deletePlant(String id) async {
    final db = await database;

    await db.delete(
      "Plant",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
//   static Future<void> createTables(sql.Database database) async {
//     await database.execute("""CREATE TABLE feeds(
//         id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
//         content, TEXT,
//         createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
//       )
//       """);
//   }
// // id: the id of a item
// // title, description: name and description of your activity
// // created_at: the time that the item was created. It will be automatically handled by SQLite

//   static Future<sql.Database> db() async {
//     return sql.openDatabase(
//       'singmul-won.db',
//       version: 1,
//       onCreate: (sql.Database database, int version) async {
//         await createTables(database);
//       },
//     );
//   }

//   // Create new item (journal)
//   static Future<int> createItem(String content) async {
//     final db = await SQLHelper.db();

//     final data = {'content': content};
//     final id = await db.insert('feeds', data,
//         conflictAlgorithm: sql.ConflictAlgorithm.replace);
//     return id;
//   }

//   // Read all items (journals)
//   static Future<List<Map<String, dynamic>>> getItems() async {
//     final db = await SQLHelper.db();
//     return db.query('feeds', orderBy: "id");
//   }

//   // Read a single item by id
//   // The app doesn't use this method but I put here in case you want to see it
//   static Future<List<Map<String, dynamic>>> getItem(int id) async {
//     final db = await SQLHelper.db();
//     return db.query('feeds', where: "id = ?", whereArgs: [id], limit: 1);
//   }

//   // Update an item by id
//   static Future<int> updateItem(int id, String content) async {
//     final db = await SQLHelper.db();

//     final data = {'content': content, 'createdAt': DateTime.now().toString()};

//     final result =
//         await db.update('feeds', data, where: "id = ?", whereArgs: [id]);
//     return result;
//   }

//   // Delete
//   static Future<void> deleteItem(int id) async {
//     final db = await SQLHelper.db();
//     try {
//       await db.delete("feeds", where: "id = ?", whereArgs: [id]);
//     } catch (err) {
//       debugPrint("Something went wrong when deleting an item: $err");
//     }
//   }
// }
