import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

import 'SQLHelper.dart';

//완료
class FeedImageSQLHelper {
  // Create new item (journal)
  static Future<int> createFeedImage(String url, [String text]) async {
    final db = await SQLHelper.db();

    final data = {'url': url, 'idx': 1};
    final id = await db.insert('feedImages', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  //이게 필요한가
  static Future<List<Map<String, dynamic>>> getFeedImages() async {
    final db = await SQLHelper.db();
    return db.query('feedImages');
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getFeedImage(int feedId) async {
    final db = await SQLHelper.db();
    return db.query('feedImages',
        where: "feedId = ?", whereArgs: [feedId], limit: 1);
  }

  // Update an item by id
  static Future<int> updateFeedImage(int feedId, String url,
      [String text]) async {
    final db = await SQLHelper.db();

    final data = {'url': url};

    final result = await db.update('feedImages', data,
        where: "feedId = ? and idx=1", whereArgs: [feedId]);
    return result;
  }

  // Delete
  static Future<void> deleteFeedImage(int feedId) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("feedImages", where: "feedId = ?", whereArgs: [feedId]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<void> dropFeedImages() async {
    final db = await SQLHelper.db();
    final result = await db.execute("""
      DROP TABLE IF EXISTS feedImages""");
  }
}
