// import 'package:flutter/foundation.dart';
// import 'package:sqflite/sqflite.dart' as sql;
// import './Provider/plant.dart';

// class PlantSQLHelper {
//   static Future<void> createTables(sql.Database database) async {
//     await database.execute("""CREATE TABLE plants(
//         id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
//         userId TEXT,
//         content TEXT,
//         imageUrl TEXT,
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
//   static Future<int> createPlant(Plant plant) async {
//     final db = await PlantSQLHelper.db();

//     //final data = {'content': content, 'createdAt': DateTime.now().toString()};
//     final data = {'water': plant.water};
//     final id = await db.insert('feeds', data,
//         conflictAlgorithm: sql.ConflictAlgorithm.replace);
//     return id;
//   }

//   // Read all items (journals)
//   static Future<List<Map<String, dynamic>>> getPlants() async {
//     final db = await PlantSQLHelper.db();
//     return db.query('feeds', orderBy: "id");
//   }

//   // Read a single item by id
//   // The app doesn't use this method but I put here in case you want to see it
//   static Future<List<Map<String, dynamic>>> getPlant(int id) async {
//     final db = await PlantSQLHelper.db();
//     return db.query('feeds', where: "id = ?", whereArgs: [id], limit: 1);
//   }

//   // Update an item by id
//   static Future<int> updatePlant(int id, String content, [String text]) async {
//     final db = await PlantSQLHelper.db();

//     final data = {'content': content, 'createdAt': DateTime.now().toString()};

//     final result =
//         await db.update('feeds', data, where: "id = ?", whereArgs: [id]);
//     return result;
//   }

//   // Delete
//   static Future<void> deletePlant(int id) async {
//     final db = await PlantSQLHelper.db();
//     try {
//       await db.delete("feeds", where: "id = ?", whereArgs: [id]);
//     } catch (err) {
//       debugPrint("Something went wrong when deleting an item: $err");
//     }
//   }
// }
