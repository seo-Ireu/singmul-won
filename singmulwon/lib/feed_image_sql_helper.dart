import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

//완료
class FeedImageSQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE feedImages(
        feedImageId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        feedId INTEGER,
        url TEXT,
        idx INTEGER,
        FOREIGN KEY(feedId) REFERENCES feeds(feedId)
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
  static Future<int> createFeedImage(String url, [String text]) async {
    final db = await FeedImageSQLHelper.db();

    final data = {'url': url, 'idx': 1};
    final id = await db.insert('feedImages', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  //이게 필요한가
  static Future<List<Map<String, dynamic>>> getFeedImages() async {
    final db = await FeedImageSQLHelper.db();
    return db.query('feedImages');
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getFeedImage(int feedId) async {
    final db = await FeedImageSQLHelper.db();
    return db.query('feedImages',
        where: "feedId = ?", whereArgs: [feedId], limit: 1);
  }

  // Update an item by id
  static Future<int> updateFeedImage(int feedId, String url,
      [String text]) async {
    final db = await FeedImageSQLHelper.db();

    final data = {'url': url};

    final result = await db.update('feedImages', data,
        where: "feedId = ? and idx=1", whereArgs: [feedId]);
    return result;
  }

  // Delete
  static Future<void> deleteFeedImage(int feedId) async {
    final db = await FeedImageSQLHelper.db();
    try {
      await db.delete("feedImages", where: "feedId = ?", whereArgs: [feedId]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<void> dropFeedImages() async {
    final db = await FeedImageSQLHelper.db();
    final result = await db.execute("""
      DROP TABLE IF EXISTS feedImages""");
  }
}
