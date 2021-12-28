// To parse this JSON data, do
//
//     final recommentUser = recommentUserFromJson(jsonString);
import 'dart:convert';

import 'package:flutter/material.dart';

UserBase recommentUserFromJson(String str) =>
    UserBase.fromJson(json.decode(str));

String recommentUserToJson(UserBase data) => json.encode(data.toJson());

class UserBase  {
  UserBase({
    required this.id,
    this.uid,
    required this.name,
    this.image = "",
    required this.sex,
    this.signature,
  });

  final String id;
  int? uid;
  final String name;
  final String image;
  final int sex;
  String? signature;

  factory UserBase.fromJson(Map<String, dynamic> json) => UserBase(
        id: json["id"],
        uid: json["uid"],
        name: json["name"],
        image: json["image"],
        sex: json["sex"],
        signature: json["signature"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "name": name,
        "image": image,
        "sex": sex,
        "signature": signature,
      };

  @override
  bool operator ==(Object other) {
    if (other is UserBase) {
      return id == other.id;
    }
    return false;
  }

  @override
  int get hashCode => hashValues(id, uid);

  @override
  String toString() {
    return 'UserBase: id——$id, uid——$uid, name——$name, sex——$sex';
  }
}
