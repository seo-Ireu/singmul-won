import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

//완료
class FeedCommentSQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE feedComments(
        feedCommentId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        userId TEXT,
        feedId INTEGER,
        comment TEXT,
        parentCommentId INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updateAt TIMESTAMP,

        FOREIGN KEY(userId) REFERENCES accounts(userId) ON DELETE CASCADE,
        FOREIGN KEY(feedId) REFERENCES feeds(feedId) ON DELETE CASCADE
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
  static Future<int> createFeedComment(String comment, [String text]) async {
    final db = await FeedCommentSQLHelper.db();

    final data = {'comment': comment, 'createdAt': DateTime.now().toString()};
    final id = await db.insert('feedComments', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getFeedComments() async {
    final db = await FeedCommentSQLHelper.db();
    return db.query('feedComments', orderBy: "createAt");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  //질문: 이게 필요한가?
  static Future<List<Map<String, dynamic>>> getFeedComment(int feedId) async {
    final db = await FeedCommentSQLHelper.db();
    return db.query('feedComments',
        where: "feedId = ?", whereArgs: [feedId], limit: 1);
  }

  // Update an item by id
  static Future<int> updateFeedComment(int feedCommentId, String comment,
      [String text]) async {
    final db = await FeedCommentSQLHelper.db();

    final data = {'comment': comment, 'updateAt': DateTime.now().toString()};

    final result = await db.update('feedComments', data,
        where: "feedCommentId = ?", whereArgs: [feedCommentId]);
    return result;
  }

  // Delete
  static Future<void> deleteFeedComment(int feedCommentId) async {
    final db = await FeedCommentSQLHelper.db();
    try {
      await db.delete("feedComments",
          where: "feedCommentId = ?", whereArgs: [feedCommentId]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<void> dropFeedComments() async {
    final db = await FeedCommentSQLHelper.db();
    final result = await db.execute("""
      DROP TABLE IF EXISTS feedComments""");
  }
}
