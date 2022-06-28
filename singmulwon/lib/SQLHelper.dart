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
class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE accounts(
        userId TEXT PRIMARY KEY NOT NULL,
        password TEXT NOT NULL,
        nickname TEXT,
        phone TEXT NOT NULL,
        profileIntro TEXT
      )
      """);
    await database.execute("""CREATE TABLE feeds(
        feedId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        userId TEXT,
        content TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updateAt TIMESTAMP,

        FOREIGN KEY(userId) REFERENCES accounts(userId) ON DELETE CASCADE
      )
      """);
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
      )""");
    await database.execute("""CREATE TABLE feedImages(
        feedImageId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        feedId INTEGER,
        url TEXT,
        idx INTEGER,
        FOREIGN KEY(feedId) REFERENCES feeds(feedId)
      )
      """);
    await database.execute("""CREATE TABLE feedLikes(
        feedLikeId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        feedId INTEGER,
        userId TEXT,
        status INTEGER,
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
}
