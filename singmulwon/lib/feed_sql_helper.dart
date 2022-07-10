import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../SQLHelper.dart';

// CREATE TABLE feeds(
//         feedId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
//         userId TEXT,
//         myPlantId INTEGER,
//         content TEXT,
//         createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
//         updateAt TIMESTAMP,

//         FOREIGN KEY("userId") REFERENCES accounts(userId),
//         FOREIGN KEY("myPlantId") REFERENCES plants(myPlantId),
//       )
class FeedSQLHelper {
  // Create new item (journal)
  static Future<int> createFeed(String userId, String content,
      [String text]) async {
    final db = await SQLHelper.db();

    final data = {
      'userId': userId,
      'content': content,
      'createdAt': DateTime.now().toString()
    };
    final id = await db.insert('feeds', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getFeeds() async {
    final db = await SQLHelper.db();
    return db.query('feeds', orderBy: "feedId");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getFeed(int id) async {
    final db = await SQLHelper.db();
    return db.query('feeds', where: "feedId = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateFeed(int id, String content, [String text]) async {
    final db = await SQLHelper.db();

    final data = {'content': content, 'createdAt': DateTime.now().toString()};

    final result =
        await db.update('feeds', data, where: "feedId = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteFeed(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("feeds", where: "feedId = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<void> dropFeeds() async {
    final db = await SQLHelper.db();
    final result = await db.execute("""
      DROP TABLE IF EXISTS feeds""");
    print("DROP TABLE");
  }
}
