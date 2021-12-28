    import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/chat.dart';


/// @author wu chao
/// @project flutter_im
/// @date 2021/8/12
class DatabaseManager {
  late Database database;

  static final DatabaseManager _instance = DatabaseManager.internal();

  DatabaseManager.internal();

  factory DatabaseManager() => _instance;

  String id = '';

  String token = '';

  open() async {
    // SpUtil sp = await SpUtil.getInstance();
    // this.token = Global.accessToken;
    // this.id =
    //     User.fromJson(jsonDecode(sp.getString(SharedPreferencesKeys.user)!)).id;
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "im$id.db");
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE chatList (
         cov_id TEXT,
         unread_count INTEGER,
         last_msg_text TEXT,
         last_msg_at TEXT,
         image TEXT,
         name TEXT,
         sex TEXT,
         chat_object_id TEXT PRIMARY KEY)
         ''');
      await db.execute('''
      CREATE TABLE chatDetail (
         chat_id TEXT PRIMARY KEY,
         from_id TEXT,
         to_id TEXT,
         created_at TEXT,
         content TEXT,
         image TEXT,
         name TEXT,
         sex TEXT,
         status TEXT,
         type INTEGER,
         chat_object_id TEXT
         )
         ''');
    });
  }

  Future insertChatList(List<ChatList> chatList) async {
    for (var data in chatList) {
      await database.insert(
        "chatList",
        data.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    return;
  }

  Future insertChatDetail(List<ChatDetail> chatDetail) async {
    for (var data in chatDetail) {
      await database.insert(
        "chatDetail",
        data.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    return;
  }

  Future<List<ChatList>> selectChatList({int skip = 0, int limit = 30}) async {
    return chatListFromSqlData(await database.rawQuery(
      'SELECT * from chatList order by last_msg_at desc limit $skip , $limit',
    ));
  }

  Future<List<ChatDetail>> selectChatDetail(String chatObjectID,
      {int skip = 0, int limit = 30}) async {
    return chatDetailFromSqlData(await database.rawQuery(
        'SELECT * from chatDetail where chat_object_id = ? order by created_at desc limit $skip , $limit',
        [chatObjectID]));
  }

  Future<List<Map<String, dynamic>>> selectChatListForID(
      String chatObjectID) async {
    return await database.rawQuery(
        'SELECT * from chatList where chat_object_id = ?', [chatObjectID]);
  }

  Future<int> updateChatList(ChatList chat) async {
    return await database.update("chatList", chat.toJson(),
        where: 'chat_object_id = ?', whereArgs: [chat.chatObjectId]);
  }

  Future<int> updateChatDetailStatus(String chatID, String rID) async {
    return await database.rawUpdate(
        'UPDATE chatDetail SET status = ? ,chat_id = ? WHERE chat_id = ?',
        ["done", chatID, rID]);
  }

  Future<int> updateChatListUnread(String chatObjectId) async {
    return await database.rawUpdate(
        'UPDATE chatList SET unread_count = ? WHERE chat_object_id = ?',
        [0, chatObjectId]);
  }

  Future deleteChatList({String? chatObjectID}) async {
    if (chatObjectID != null) {
      int count = await database.rawDelete(
          'delete from chatList where chat_object_id = ?', [chatObjectID]);
      debugPrint("delete count:$count");
      return;
    }
    int count = await database.rawDelete(
      'delete from chatList',
    );
    debugPrint("delete count:$count");
    return;
  }

  Future initChatList() async {
    await DatabaseManager().open();
    int skip = 0;
    int total;
    int limit = 30;
    var data;
    try {
      // data = await HttpUtils.get(API_P2P_LIST,
      //     params: {
      //       "skip": skip,
      //       "limit": limit,
      //     });
    } catch (e) {
      print("初始化消息列表总数失败");
      return;
    }
    debugPrint("get success");
    if (data == null || data["data"]["total"] == 0) return;
    total = data["data"]["total"];
    await DatabaseManager().deleteChatList();
    for (; skip < total; skip += limit) {
      var data;
      try {
        // data = await HttpUtils.get(API_P2P_LIST,
        //     params: {
        //       "skip": skip,
        //       "limit": limit,
        //     });
      } catch (e) {
        print("初始化消息列表请求失败");
        return;
      }
      await DatabaseManager()
          .insertChatList(chatListFromJson(data["data"]["datas"]));
    }
  }
}
