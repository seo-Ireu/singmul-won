import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

//완료
class AccountSQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE accounts(
        userId TEXT PRIMARY KEY NOT NULL,
        password TEXT NOT NULL,
        nickname TEXT,
        phone TEXT NOT NULL,
        profileIntro TEXT
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
  static Future<int> createAccount(String userId, String password,
      String nickname, String phone, String profileIntro,
      [String text]) async {
    final db = await AccountSQLHelper.db();

    final data = {
      'userId': userId,
      'password': password,
      'nickname': nickname,
      'phone': phone,
      'profileIntro': profileIntro
    };
    final id = await db.insert('accounts', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getAccounts() async {
    final db = await AccountSQLHelper.db();
    return db.query('accounts', orderBy: "userId");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getAccount(int userId) async {
    final db = await AccountSQLHelper.db();
    return db.query('accounts',
        where: "userId = ?", whereArgs: [userId], limit: 1);
  }

  // Update an item by id
  static Future<int> updateAccount(String userId, String password,
      String nickname, String phone, String profileIntro,
      [String text]) async {
    final db = await AccountSQLHelper.db();

    final data = {
      'password': password,
      'nickname': nickname,
      'phone': phone,
      'profileIntro': profileIntro,
    };

    final result = await db
        .update('accounts', data, where: "userId = ?", whereArgs: [userId]);
    return result;
  }

  // Delete
  static Future<void> deleteAccount(int userId) async {
    final db = await AccountSQLHelper.db();
    try {
      await db.delete("accounts", where: "id = ?", whereArgs: [userId]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
