/// @author wu chao
/// @project flutter_im
/// @date 2021/8/12
import 'dart:convert';

SocketMessage socketMessageFromJson(String str) =>
    SocketMessage.fromJson(json.decode(str));

String socketMessageToJson(SocketMessage data) => json.encode(data.toJson());

class SocketMessage {
  SocketMessage({
    required this.type,
    this.code,
    required this.payload,
    required this.msgTime,
  });

  String type;
  int? code;
  dynamic payload;
  int msgTime;

  factory SocketMessage.fromJson(Map<String, dynamic> json) => SocketMessage(
        type: json["type"],
        code: json["code"],
        payload: json["payload"],
        msgTime: json["msg_time"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "code": code,
        "payload": payload,
        "msg_time": msgTime,
      };
}
