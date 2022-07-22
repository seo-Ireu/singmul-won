// import 'package:flutter/foundation.dart';
// import 'package:flutter_singmulwon_app/SQLHelper.dart';
// import 'package:sqflite/sqflite.dart' as sql;

// //완료
// class AccountSQLHelper {
//   // Create new item (journal)
//   static Future<int> createAccount(String userId, String password,
//       String nickname, String phone, String profileIntro,
//       [String text]) async {
//     final db = await SQLHelper.db();

//     final data = {
//       'userId': userId,
//       'password': password,
//       'nickname': nickname,
//       'phone': phone,
//       'profileIntro': profileIntro
//     };
//     final id = await db.insert('accounts', data,
//         conflictAlgorithm: sql.ConflictAlgorithm.replace);
//     return id;
//   }

//   // Read all items (journals)
//   static Future<List<Map<String, dynamic>>> getAccounts() async {
//     final db = await SQLHelper.db();
//     return db.query('accounts', orderBy: "userId");
//   }

//   // Read a single item by id
//   // The app doesn't use this method but I put here in case you want to see it
//   static Future<List<Map<String, dynamic>>> getAccount(int userId) async {
//     final db = await SQLHelper.db();
//     return db.query('accounts',
//         where: "userId = ?", whereArgs: [userId], limit: 1);
//   }

//   // Update an item by id
//   static Future<int> updateAccount(String userId, String password,
//       String nickname, String phone, String profileIntro,
//       [String text]) async {
//     final db = await SQLHelper.db();

//     final data = {
//       'password': password,
//       'nickname': nickname,
//       'phone': phone,
//       'profileIntro': profileIntro,
//     };

//     final result = await db
//         .update('accounts', data, where: "userId = ?", whereArgs: [userId]);
//     return result;
//   }

//   // Delete
//   static Future<void> deleteAccount(int userId) async {
//     final db = await SQLHelper.db();
//     try {
//       await db.delete("accounts", where: "id = ?", whereArgs: [userId]);
//     } catch (err) {
//       debugPrint("Something went wrong when deleting an item: $err");
//     }
//   }
// }
