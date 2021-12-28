/// @author wu chao
/// @project flutter_im
/// @date 2021/8/12
import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../util/database_manager.dart';

List<ChatList> chatListFromJson(List chatList) =>
    List<ChatList>.from(chatList.map((x) => ChatList.fromJson(x)));

List<ChatList> chatListFromSqlData(List chatList) =>
    List<ChatList>.from(chatList.map((x) => ChatList.fromSqlData(x)));

String chatListToJson(ChatList data) => json.encode(data.toJson());

class ChatList {
  ChatList(
      {required this.covId,
      required this.lastMsgText,
      required this.lastMsgAt,
      required this.unreadCount,
      required this.image,
      required this.name,
      required this.sex,
      required this.chatObjectId});

  String covId;
  String lastMsgText;
  DateTime lastMsgAt;
  int unreadCount;
  String image;
  String name;
  String sex;
  String chatObjectId;

  factory ChatList.fromJson(Map<String, dynamic> json) => ChatList(
        covId: json["cov_id"],
        unreadCount: json["unread_count"],
        lastMsgText: json["last_msg_text"],
        lastMsgAt: DateTime.parse(json["last_msg_at"]),
        chatObjectId: json["ui"] == null ? json["from_id"] : json["ui"]["id"],
        name: json["ui"] == null ? "脏数据" : json["ui"]["name"],
        sex: json["ui"] == null ? "1" : json["ui"]["sex"].toString(),
        image: json["ui"] == null || json["ui"]["image"] == null
            ? "http://werewolf-image.xiaobanhui.com/0ac5e8f0-ab05-11ea-9040-4fca266cc85f?imageslim"
            : json["ui"]["image"],
      );

  factory ChatList.fromSqlData(Map<String, dynamic> sqlData) => ChatList(
        covId: sqlData["cov_id"],
        unreadCount: sqlData["unread_count"],
        lastMsgText: sqlData["last_msg_text"],
        lastMsgAt: DateTime.parse(sqlData["last_msg_at"]),
        chatObjectId: sqlData["chat_object_id"],
        name: sqlData["name"],
        sex: sqlData["sex"],
        image: sqlData["image"],
      );

  factory ChatList.fromSocketJson(Map<String, dynamic> socketJson) => ChatList(
        covId: Uuid().v1().replaceAll("-", ""),
        unreadCount: 1,
        lastMsgText: socketJson["cov_data"]["data"]["text"],
        lastMsgAt: DateTime.parse(socketJson["created_at"]),
        chatObjectId: socketJson["from_id"],
        name: socketJson["cov_data"]["data"]["attrs"]["USER_NAME"],
        sex: socketJson["cov_data"]["data"]["attrs"]["USER_SEX"].toString(),
        image: socketJson["cov_data"]["data"]["attrs"]["USER_ICON"],
      );

  Map<String, dynamic> toJson() => {
        "cov_id": covId,
        "unread_count": unreadCount,
        "last_msg_text": lastMsgText,
        "last_msg_at": lastMsgAt.toIso8601String(),
        "image": image,
        "name": name,
        "sex": sex,
        "chat_object_id": chatObjectId,
      };
}

List<ChatDetail> chatDetailFromGCDSSocketJson(List chatDetail) =>
    List<ChatDetail>.from(
        chatDetail.map((x) => ChatDetail.fromGCDSSocketJson(x)));

List<ChatDetail> chatDetailFromSqlData(List chatDetail) =>
    List<ChatDetail>.from(chatDetail.map((x) => ChatDetail.fromSqlData(x)));

class ChatDetail {
  ChatDetail(
      {required this.chatID,
      required this.fromID,
      required this.toID,
      required this.content,
      required this.createdAt,
      required this.image,
      required this.name,
      required this.sex,
      required this.status,
      required this.type,
      required this.chatObjectId});

  //done, fail, wait
  String status;
  String chatID;
  String fromID;
  String toID;
  String content;
  DateTime createdAt;
  String image;
  String name;
  String sex;
  num type;
  String chatObjectId;

  factory ChatDetail.fromGCDSSocketJson(Map<String, dynamic> socketJson) {
    return ChatDetail(
      chatID: socketJson["_id"],
      fromID: socketJson["from_id"],
      toID: socketJson["to_id"],
      content: getContent(socketJson),
      createdAt: DateTime.parse(socketJson["created_at"]),
      image: socketJson["cov_data"]["data"]["attrs"]["USER_ICON"],
      name: socketJson["cov_data"]["data"]["attrs"]["USER_NAME"],
      sex: socketJson["cov_data"]["data"]["attrs"]["USER_SEX"].toString(),
      status: "done",
      type: socketJson["cov_data"]["mType"],
      chatObjectId: socketJson["cov_data"]["data"]["attrs"]["USER_ID"] !=
              DatabaseManager().id
          ? socketJson["cov_data"]["data"]["attrs"]["USER_ID"]
          : socketJson["to_id"],
    );
  }

  factory ChatDetail.fromP2PSocketJson(Map<String, dynamic> socketJson) =>
      ChatDetail(
        chatID: socketJson["_id"],
        fromID: socketJson["from_id"],
        toID: socketJson["to_id"],
        content: getContent(socketJson),
        createdAt: DateTime.now(),
        image: socketJson["cov_data"]["data"]["attrs"]["USER_ICON"],
        name: socketJson["cov_data"]["data"]["attrs"]["USER_NAME"],
        sex: socketJson["cov_data"]["data"]["attrs"]["USER_SEX"].toString(),
        status: "done",
        type: socketJson["cov_data"]["mType"],
        chatObjectId: socketJson["cov_data"]["data"]["attrs"]["USER_ID"] !=
                DatabaseManager().id
            ? socketJson["cov_data"]["data"]["attrs"]["USER_ID"]
            : socketJson["to_id"],
      );

  factory ChatDetail.fromSqlData(Map<String, dynamic> sqlData) => ChatDetail(
        chatID: sqlData["chat_id"],
        fromID: sqlData["from_id"],
        toID: sqlData["to_id"],
        content: sqlData["content"],
        createdAt: DateTime.parse(sqlData["created_at"]),
        image: sqlData["image"],
        name: sqlData["name"],
        sex: sqlData["sex"],
        status: sqlData["status"],
        type: sqlData["type"],
        chatObjectId: sqlData["chat_object_id"],
      );

  static String getContent(socketJson) {
    if (socketJson["cov_data"]["mType"] == -1)
      return socketJson["cov_data"]["data"]["text"];
    if (socketJson["cov_data"]["mType"] == -2)
      return socketJson["cov_data"]["data"]["file"]["url"];
    return "";
  }

  Map<String, dynamic> toJson() => {
        "chat_id": chatID,
        "from_id": fromID,
        "to_id": toID,
        "content": content,
        "created_at": createdAt.toIso8601String(),
        "image": image,
        "name": name,
        "sex": sex,
        "chat_object_id": chatObjectId,
        "type": type,
        "status": status,
      };
}

class ManyChatDetail {
  String content;
  String image;
  DateTime time;
  String name;
  String id;
  bool flag;

  ManyChatDetail(
      {required this.content,
        required this.image,
        required this.time,
        required this.name,
        required this.flag,
        required this.id
      });
}
