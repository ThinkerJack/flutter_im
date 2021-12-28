// To parse this JSON data, do
//
//     final friends = friendsFromJson(jsonString);

import 'dart:convert';


Friends friendsFromJson(String str) => Friends.fromJson(json.decode(str));

String friendsToJson(Friends data) => json.encode(data.toJson());

class Friends {
  Friends({
    this.page,
    this.totalPage,
    this.totalUser,
    this.serverTime,
    this.list,
  });

  int? page;
  int? totalPage;
  int? totalUser;
  int? serverTime;
  List<Friend>? list;

  factory Friends.fromJson(Map<String, dynamic> json) => Friends(
    page: json["page"],
    totalPage: json["total_page"],
    totalUser: json["total_user"],
    serverTime: json["server_time"],
    list: List<Friend>.from(json["list"].map((x) => Friend.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "total_page": totalPage,
    "total_user": totalUser,
    "server_time": serverTime,
    "list": List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class Friend {
  Friend({
    this.id,
    this.image,
    this.name,
    this.sex,
    this.signature,
    this.uid,
    this.petHomeLv,
    this.status,
    this.listId,
    this.inTop,
  });

  String? id;
  String? image;
  String? name;
  int? sex;
  String? signature;
  int? uid;
  int? petHomeLv;
  String? status;
  String? listId;
  bool? inTop;

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
    id: json["_id"],
    image: json["image"],
    name: json["name"],
    sex: json["sex"],
    signature: json["signature"],
    uid: json["uid"],
    petHomeLv: json["petHomeLv"],
    status: json["status"],
    listId: json["id"],
    inTop: json["in_top"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "image": image,
    "name": name,
    "sex": sex,
    "signature": signature,
    "uid": uid,
    "petHomeLv": petHomeLv,
    "status": status,
    "id": listId,
    "in_top": inTop,
  };
}

FriendRequest friendRequestFromJson(String str) =>
    FriendRequest.fromJson(json.decode(str));

String friendRequestToJson(FriendRequest data) => json.encode(data.toJson());

class FriendRequest {
  FriendRequest({
    this.updateCount,
    this.serverTime,
    this.page,
    this.totalPage,
    this.totalUser,
    this.list,
  });

  int? updateCount;
  int? serverTime;
  int? page;
  int? totalPage;
  int? totalUser;
  List<FriendInfo>? list;

  factory FriendRequest.fromJson(Map<String, dynamic> json) => FriendRequest(
        updateCount: json["update_count"],
        serverTime: json["server_time"],
        page: json["page"],
        totalPage: json["total_page"],
        totalUser: json["total_user"],
        list: List<FriendInfo>.from(
            json["list"].map((x) => FriendInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "update_count": updateCount,
        "server_time": serverTime,
        "page": page,
        "total_page": totalPage,
        "total_user": totalUser,
        "list": List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class FriendInfo {
  FriendInfo({
    this.id,
    this.name,
    this.image,
    this.sex,
    this.status,
  });

  String? id;
  String? name;
  String? image;
  int? sex;
  String? status;

  factory FriendInfo.fromJson(Map<String, dynamic> json) => FriendInfo(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        sex: json["sex"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "sex": sex,
        "status": status,
      };
}
class NewFansJson {
  NewFansJson({
    this.total,
    this.userId,
    this.notiType,
    this.skip,
    this.limit,
    this.datas,
  });

  int? total;
  String? userId;
  String? notiType;
  int? skip;
  int? limit;
  List<NewFansElement>? datas;

  factory NewFansJson.fromJson(Map<String, dynamic> json) => NewFansJson(
    total: json["total"],
    userId: json["userId"],
    notiType: json["notiType"],
    skip: json["skip"],
    limit: json["limit"],
    datas: List<NewFansElement>.from(
        json["datas"].map((x) => NewFansElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "userId": userId,
    "notiType": notiType,
    "skip": skip,
    "limit": limit,
    "datas": List<dynamic>.from(datas!.map((x) => x.toJson())),
  };
}

class NewFansElement {
  NewFansElement({
    this.id,
    this.poster,
    this.userId,
    this.data,
    this.targetId,
    this.updatedAt,
    this.createdAt,
    this.status,
  });

  String? id;
  Poster? poster;
  String? userId;
  NewFansData? data;
  String? targetId;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? status;

  factory NewFansElement.fromJson(Map<String, dynamic> json) => NewFansElement(
    id: json["_id"],
    poster: Poster.fromJson(json["poster"]),
    userId: json["user_id"],
    data: NewFansData.fromJson(json["data"]),
    targetId: json["target_id"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "poster": poster?.toJson(),
    "user_id": userId,
    "data": data?.toJson(),
    "target_id": targetId,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "status": status,
  };
}

class NewFansData {
  NewFansData({
    this.poster,
  });

  Poster? poster;

  factory NewFansData.fromJson(Map<String, dynamic> json) => NewFansData(
    poster: Poster.fromJson(json["poster"]),
  );

  Map<String, dynamic> toJson() => {
    "poster": poster?.toJson(),
  };
}
class Poster {
  Poster({
    required this.userId,
    required this.name,
    required this.image,
    this.influential,
  });

  String userId;
  String name;
  String? image;
  bool? influential;

  factory Poster.fromJson(Map<String, dynamic> json) => Poster(
    userId: json["user_id"],
    name: json["name"],
    image: json["image"],
    influential: json["influential"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "name": name,
    "image": image,
    "influential": influential,
  };
}
