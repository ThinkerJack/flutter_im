/*
* 代码注释
* 说明：用户登录信息
* 模块：
* 作者：rzheng
* 时间：2021-08-10 16:55:46 Tuesday
*/
// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.id,
    required this.name,
    required this.sex,
    required this.image,
    required this.game,
    required this.regTime,
    required this.token,
    required this.info,
    required this.signature,
    required this.type,
    required this.photos,
    required this.privacy,
    required this.gift,
    required this.undercover,
    required this.money,
    required this.role,
    required this.uid,
    required this.active,
    required this.popular,
    required this.beLiked,
    required this.pet,
    this.vipInfo,
    this.avatarBox,
    this.messageBox,
    this.roomCoverDecor,
    this.micEffect,
    this.upseatEffect,
    this.cardEffect,
    this.ownerEffect,
  });

  String id;
  String name;
  int sex;
  String image;
  Game game;
  int regTime;
  Token token;
  Info info;
  String signature;
  int type;
  List<Photo> photos;
  Privacy privacy;
  List<Gift> gift;
  AvatarBox undercover;
  Money money;
  Role role;
  int uid;
  Active active;
  int popular;
  int beLiked;
  Pet pet;
  VipInfo? vipInfo;
  AvatarBox? avatarBox;
  AvatarBox? messageBox;
  AvatarBox? roomCoverDecor;
  AvatarBox? micEffect;
  AvatarBox? upseatEffect;
  AvatarBox? cardEffect;
  AvatarBox? ownerEffect;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        sex: json["sex"],
        image: (json["image"] == '' || json["image"] == null)
            ? 'https://werewolf-image.xiaobanhui.com/default/male_wolf.png'
            : json["image"],
        game: Game.fromJson(json["game"]),
        regTime: json["reg_time"],
        token: Token.fromJson(json["token"]),
        info: Info.fromJson(json["info"]),
        signature: json["signature"],
        type: json["type"],
        photos: List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
        privacy: Privacy.fromJson(json["privacy"]),
        gift: List<Gift>.from(json["gift"].map((x) => Gift.fromJson(x))),
        undercover: AvatarBox.fromJson(json["undercover"]),
        money: Money.fromJson(json["money"]),
        role: Role.fromJson(json["role"]),
        uid: json["uid"],
        active: Active.fromJson(json["active"]),
        popular: json["popular"],
        beLiked: json["be_liked"],
        pet: Pet.fromJson(json["pet"]),
        vipInfo: VipInfo.fromJson(json["vipInfo"]),
        avatarBox: AvatarBox.fromJson(json["avatar_box"]),
        messageBox: AvatarBox.fromJson(json["message_box"]),
        roomCoverDecor: AvatarBox.fromJson(json["room_cover_decor"]),
        micEffect: AvatarBox.fromJson(json["mic_effect"]),
        upseatEffect: AvatarBox.fromJson(json["upseat_effect"]),
        cardEffect: AvatarBox.fromJson(json["card_effect"]),
        ownerEffect: AvatarBox.fromJson(json["owner_effect"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "sex": sex,
        "image": image,
        "game": game.toJson(),
        "reg_time": regTime,
        "token": token.toJson(),
        "info": info.toJson(),
        "signature": signature,
        "type": type,
        "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
        "privacy": privacy.toJson(),
        "gift": List<dynamic>.from(gift.map((x) => x.toJson())),
        "undercover": undercover.toJson(),
        "money": money.toJson(),
        "role": role.toJson(),
        "uid": uid,
        "active": active.toJson(),
        "popular": popular,
        "be_liked": beLiked,
        "pet": pet.toJson(),
        "vipInfo": vipInfo?.toJson(),
        "avatar_box": avatarBox?.toJson(),
        "message_box": messageBox?.toJson(),
        "room_cover_decor": roomCoverDecor?.toJson(),
        "mic_effect": micEffect?.toJson(),
        "upseat_effect": upseatEffect?.toJson(),
        "card_effect": cardEffect?.toJson(),
        "owner_effect": ownerEffect?.toJson(),
      };

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        sex: json["sex"],
        image: json["image"],
        game: Game.fromJson(jsonDecode(json["game"])),
        regTime: json["reg_time"],
        token: Token.fromJson(jsonDecode(json["token"])),
        info: Info.fromJson(jsonDecode(json["info"])),
        signature: json["signature"],
        type: json["type"],
        photos: List<Photo>.from(
            jsonDecode(json["photos"]).map((x) => Photo.fromJson(x))),
        privacy: Privacy.fromJson(jsonDecode(json["privacy"])),
        gift: List<Gift>.from(
            jsonDecode(json["gift"]).map((x) => Gift.fromJson(x))),
        undercover: AvatarBox.fromJson(jsonDecode(json["undercover"])),
        money: Money.fromJson(jsonDecode(json["money"])),
        role: Role.fromJson(jsonDecode(json["role"])),
        uid: json["uid"],
        active: Active.fromJson(jsonDecode(json["active"])),
        popular: json["popular"],
        beLiked: json["be_liked"],
        pet: Pet.fromJson(jsonDecode(json["pet"])),
        vipInfo: VipInfo.fromJson(jsonDecode(json["vipInfo"])),
        avatarBox: AvatarBox.fromJson(jsonDecode(json["avatar_box"])),
        messageBox: AvatarBox.fromJson(jsonDecode(json["message_box"])),
        roomCoverDecor:
            AvatarBox.fromJson(jsonDecode(json["room_cover_decor"])),
        micEffect: AvatarBox.fromJson(jsonDecode(json["mic_effect"])),
        upseatEffect: AvatarBox.fromJson(jsonDecode(json["upseat_effect"])),
        cardEffect: AvatarBox.fromJson(jsonDecode(json["card_effect"])),
        ownerEffect: AvatarBox.fromJson(jsonDecode(json["owner_effect"])),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "sex": sex,
        "image": image,
        "game": jsonEncode(game.toJson()),
        "reg_time": regTime,
        "token": jsonEncode(token.toJson()),
        "info": jsonEncode(info.toJson()),
        "signature": signature,
        "type": type,
        "photos": jsonEncode(List<dynamic>.from(photos.map((x) => x.toJson()))),
        "privacy": jsonEncode(privacy.toJson()),
        "gift": jsonEncode(List<dynamic>.from(gift.map((x) => x.toJson()))),
        "undercover": jsonEncode(undercover.toJson()),
        "money": jsonEncode(money.toJson()),
        "role": jsonEncode(role.toJson()),
        "uid": uid,
        "active": jsonEncode(active.toJson()),
        "popular": popular,
        "be_liked": beLiked,
        "pet": jsonEncode(pet.toJson()),
        "vipInfo": jsonEncode(vipInfo?.toJson()),
        "avatar_box": jsonEncode(avatarBox?.toJson()),
        "message_box": jsonEncode(messageBox?.toJson()),
        "room_cover_decor": jsonEncode(roomCoverDecor?.toJson()),
        "mic_effect": jsonEncode(micEffect?.toJson()),
        "upseat_effect": jsonEncode(upseatEffect?.toJson()),
        "card_effect": jsonEncode(cardEffect?.toJson()),
        "owner_effect": jsonEncode(ownerEffect?.toJson()),
      };
}

class Active {
  Active({
    required this.star,
    required this.title,
    required this.experience,
    required this.type,
    required this.level,
    required this.index,
  });

  int star;
  String title;
  int experience;
  String type;
  int level;
  int index;

  factory Active.fromJson(Map<String, dynamic> json) => Active(
        star: json["star"],
        title: json["title"],
        experience: json["experience"],
        type: json["type"],
        level: json["level"],
        index: json["index"],
      );

  Map<String, dynamic> toJson() => {
        "star": star,
        "title": title,
        "experience": experience,
        "type": type,
        "level": level,
        "index": index,
      };
}

class AvatarBox {
  AvatarBox();

  factory AvatarBox.fromJson(Map<String, dynamic> json) => AvatarBox();

  Map<String, dynamic> toJson() => {};
}

class Game {
  Game({
    required this.experience,
    required this.win,
    required this.lose,
    required this.escape,
    required this.level,
  });

  int experience;
  int win;
  int lose;
  int escape;
  int level;

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        experience: json["experience"],
        win: json["win"],
        lose: json["lose"],
        escape: json["escape"],
        level: json["level"],
      );

  Map<String, dynamic> toJson() => {
        "experience": experience,
        "win": win,
        "lose": lose,
        "escape": escape,
        "level": level,
      };
}

class Gift {
  Gift({
    required this.type,
    required this.count,
  });

  String type;
  int count;

  factory Gift.fromJson(Map<String, dynamic> json) => Gift(
        type: json["type"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "count": count,
      };
}

class Info {
  Info({
    required this.vip,
  });

  int vip;

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        vip: json["vip"],
      );

  Map<String, dynamic> toJson() => {
        "vip": vip,
      };
}

class Money {
  Money({
    required this.gold,
    required this.dim,
  });

  int gold;
  int dim;

  factory Money.fromJson(Map<String, dynamic> json) => Money(
        gold: json["gold"],
        dim: json["dim"],
      );

  Map<String, dynamic> toJson() => {
        "gold": gold,
        "dim": dim,
      };
}

class Pet {
  Pet({
    required this.type,
  });

  String type;

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
      };
}

class Photo {
  Photo({
    required this.photoId,
    required this.url,
    required this.id,
    required this.thumbnailUrl,
  });

  String photoId;
  String url;
  String id;
  String thumbnailUrl;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        photoId: json["id"],
        url: json["url"],
        id: json["_id"],
        thumbnailUrl: json["thumbnail_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": photoId,
        "url": url,
        "_id": id,
        "thumbnail_url": thumbnailUrl,
      };
}

class Privacy {
  Privacy({
    required this.state,
  });

  int state;

  factory Privacy.fromJson(Map<String, dynamic> json) => Privacy(
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "state": state,
      };
}

class Role {
  Role({
    required this.custom,
    required this.customs,
  });

  String custom;
  List<dynamic> customs;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        custom: json["custom"],
        customs: List<dynamic>.from(json["customs"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "custom": custom,
        "customs": List<dynamic>.from(customs.map((x) => x)),
      };
}

class Token {
  Token({
    required this.atExpiredAt,
    required this.accessToken,
  });

  DateTime atExpiredAt;
  String accessToken;

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        atExpiredAt: DateTime.parse(json["at_expired_at"]),
        accessToken: json["access_token"],
      );

  Map<String, dynamic> toJson() => {
        "at_expired_at": atExpiredAt.toIso8601String(),
        "access_token": accessToken,
      };
}

class VipInfo {
  VipInfo({
    required this.active,
    required this.appType,
  });

  bool active;
  String appType;

  factory VipInfo.fromJson(Map<String, dynamic> json) => VipInfo(
        active: json["active"],
        appType: json["appType"],
      );

  Map<String, dynamic> toJson() => {
        "active": active,
        "appType": appType,
      };
}
