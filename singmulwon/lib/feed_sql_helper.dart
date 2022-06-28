import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

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
  static Future<void> createTables(sql.Database database) async {
    await database.execute(
        """CREATE TABLE feeds(
        feedId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        userId TEXT,
        content TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updateAt TIMESTAMP,

        FOREIGN KEY(userId) REFERENCES accounts(userId) ON DELETE CASCADE
      )
      """);
  }

// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite
  static _onConfigure(sql.Database database) async {
    // Add support for cascade delete
    await database.execute("PRAGMA foreign_keys = ON");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('singmul-won.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    }, onConfigure: _onConfigure);
  }

  // Create new item (journal)
  static Future<int> createFeed(String content, [String text]) async {
    final db = await FeedSQLHelper.db();

    final data = {'content': content, 'createdAt': DateTime.now().toString()};
    final id = await db.insert('feeds', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getFeeds() async {
    final db = await FeedSQLHelper.db();
    return db.query('feeds', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getFeed(int id) async {
    final db = await FeedSQLHelper.db();
    return db.query('feeds', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateFeed(int id, String content, [String text]) async {
    final db = await FeedSQLHelper.db();

    final data = {'content': content, 'createdAt': DateTime.now().toString()};

    final result =
        await db.update('feeds', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteFeed(int id) async {
    final db = await FeedSQLHelper.db();
    try {
      await db.delete("feeds", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<void> dropFeeds() async {
    final db = await FeedSQLHelper.db();
    final result = await db.execute("""
      DROP TABLE IF EXISTS feeds""");
    print("DROP TABLE");
  }
}
