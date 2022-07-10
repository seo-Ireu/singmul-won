// import 'package:flutter/foundation.dart';
// import 'package:sqflite/sqflite.dart' as sql;
// import 'package:sqflite/utils/utils.dart';

// import '../SQLHelper.dart';

// //완료
// class FeedLikesSQLHelper {
//   // Create new item (journal)
//   static Future<int> createFeedLike(int feedId, String userId, bool status,
//       [String text]) async {
//     final db = await SQLHelper.db();

//     final id = await db.insert('feedLikes',
//         {'feedId': feedId, 'userId': userId, 'status': status == true ? 1 : 0},
//         conflictAlgorithm: sql.ConflictAlgorithm.replace);
//     return id;
//   }

//   // Read all items (journals)
//   //질문: 이게 필요한가?
//   static Future<List<Map<String, dynamic>>> getFeedLikes() async {
//     final db = await SQLHelper.db();
//     return db.query('feedLikes', orderBy: "userId");
//   }

//   // Read a single item by id
//   // The app doesn't use this method but I put here in case you want to see it
//   static Future<List<Map<String, dynamic>>> getFeedLike(
//       String userId, int feedId) async {
//     final db = await SQLHelper.db();
//     return db.query('feedLikes',
//         where: "userId = ? and feedId = ?",
//         whereArgs: [userId, feedId],
//         limit: 1);
//   }

//   // Update an item by id
//   static Future<int> updateFeedLike(String userId, int feedId, bool status,
//       [String text]) async {
//     final db = await SQLHelper.db();

//     final result = await db.update(
//         'feedLikes', {'status': status == true ? 1 : 0},
//         where: "userId = ? and feedId = ?", whereArgs: [userId, feedId]);
//     return result;
//   }

//   // Delete
//   // static Future<void> deleteFeed(int id) async {
//   //   final db = await SQLHelper.db();
//   //   try {
//   //     await db.delete("feeds", where: "id = ?", whereArgs: [id]);
//   //   } catch (err) {
//   //     debugPrint("Something went wrong when deleting an item: $err");
//   //   }
//   // }

//   static Future<void> dropFeedLikes() async {
//     final db = await SQLHelper.db();
//     final result = await db.execute("""
//       DROP TABLE IF EXISTS feedLikes""");
//   }

//   static Future<void> countFeedLikes(int feedId) async {
//     final db = await SQLHelper.db();
//     final result = await db
//         .rawQuery('SELECT COUNT(*) FROM feedLikes WHERE feedId = ? ', [feedId]);
//     final count = firstIntValue(result);
//     return count;
//   }
// }
