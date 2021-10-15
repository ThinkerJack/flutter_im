import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im/model/chat.dart';
import 'package:flutter_im/model/my_info.dart';
import 'package:flutter_im/util/adapt.dart';
import 'package:flutter_im/util/database_manager.dart';
import 'package:flutter_im/util/socket_manager.dart';
import 'package:flutter_im/util/socket_notifier.dart';
import 'package:uuid/uuid.dart';

/// @author wu chao
/// @project flutter_im
/// @date 2021/8/16
class ChatDetailPage extends StatefulWidget {
  ChatDetailPage({
    Key? key,
    required this.chatObjectId,
    required this.chatObjectSex,
    required this.chatObjectImage,
    required this.chatObjectName,
  }) : super(key: key);
  String chatObjectId;
  String chatObjectImage;
  String chatObjectName;
  String chatObjectSex;

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  late Timer timer;
  List<ChatDetail> chatDetail = [];
  late final function;
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    getData();
    SocketManager().inChat(widget.chatObjectId);
    SocketManager().chatID = widget.chatObjectId;
    timer = Timer.periodic(Duration(seconds: 40), (timer) {
      SocketManager().inChat(widget.chatObjectId);
    });
    DatabaseManager().updateChatListUnread(widget.chatObjectId);
    SocketManager().getChatDetail(widget.chatObjectId);
    function = () {
      getData();
    };
    P2PNotifier().addListener(function);
  }

  getData() async {
    chatDetail = await DatabaseManager().selectChatDetail(widget.chatObjectId);
    print(chatDetail);
    setState(() {});
  }

  send() {
    if (textEditingController.text != "") {
      String content = textEditingController.text;
      textEditingController.text = '';
      String msgID = Uuid().v1().replaceAll("-", "");
      ChatDetail chatDetail = ChatDetail(
        chatID: msgID,
        fromID: MyInfo.id,
        toID: widget.chatObjectId,
        content: content,
        createdAt: DateTime.now(),
        image: MyInfo.image,
        name: MyInfo.name,
        sex: MyInfo.sex,
        status: "wait",
        type: -1,
        chatObjectId: widget.chatObjectId,
      );
      DatabaseManager().insertChatDetail([chatDetail]).then((value) {
        getData();
        String talkData = '''{"type":"cs_cp2p",
            "payload":{
            "cd":{
            "data":{
            "attrs":{
            "MSG_TYPE":"SINGLE",
            "USER_SEX":"${MyInfo.sex}",
            "USER_ID":"${MyInfo.id}",
            "USER_NAME":"${MyInfo.name}",
            "USER_ICON":"${MyInfo.image}",
            "CHAT_TIME":"${DateTime.now().millisecondsSinceEpoch}"},
            "text":"$content"},"mType":-1},
            "tid":"${widget.chatObjectId}"},
            "msg_id":"$msgID"}''';
        SocketManager().talk(talkData);
      });
    }
  }

  @override
  void dispose() {
    timer.cancel();
    SocketManager().chatID = '';
    P2PNotifier().removeListener(function);
    SocketManager().leaveChat(widget.chatObjectId);
    //维护消息列表chat list
    DatabaseManager().selectChatListForID(widget.chatObjectId).then((chat) {
      print("chat:$chat");
      ChatList newChat = ChatList(
          covId: Uuid().v1().replaceAll("-", ""),
          lastMsgText:
              chatDetail[0].type == -1 ? chatDetail[0].content : "[图片]",
          lastMsgAt: DateTime.now(),
          unreadCount: 0,
          image: widget.chatObjectImage,
          name: widget.chatObjectName,
          sex: widget.chatObjectSex,
          chatObjectId: widget.chatObjectId);
      if (chat.length == 0) {
        DatabaseManager().insertChatList([newChat]);
      }
      if (chat.length != 0) {
        DatabaseManager().updateChatList(newChat);
      }
      P2PNotifier().notice();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
      appBar: AppBar(
        title: Text("聊天"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              reverse: true,
              controller: scrollController,
              children: [
                SizedBox(
                  height: 30.px,
                ),
                for (int i = 0; i < chatDetail.length - 1; i++)
                  (chatDetail[i].fromID == chatDetail[i].chatObjectId)
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(90.px)),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.network(
                                    chatDetail[i].image,
                                    width: 80.px,
                                    height: 80.px,
                                  ),
                                ),
                                SizedBox(width: 20.px),
                                if (chatDetail[i].type == -2)
                                  Image.network(
                                    chatDetail[i].content,
                                    width: 300.px,
                                  ),
                                if (chatDetail[i].type == -1)
                                  Container(
                                    padding: EdgeInsets.fromLTRB(
                                        20.px, 20.px, 20.px, 20.px),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(20.px),
                                      color: Colors.indigoAccent,
                                    ),
                                    child: Text(
                                      "${chatDetail[i].content}:${chatDetail[i].status}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: 30.px,
                            )
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (chatDetail[i].type == -2)
                                  Image.network(
                                    chatDetail[i].content,
                                    width: 300.px,
                                  ),
                                if (chatDetail[i].type == -1)
                                  Container(
                                    padding: EdgeInsets.fromLTRB(
                                        20.px, 20.px, 20.px, 20.px),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(20.px),
                                      color: Colors.white,
                                    ),
                                    child: Text(
                                      "${chatDetail[i].content}:${chatDetail[i].status}",
                                    ),
                                  ),
                                SizedBox(width: 20.px),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(90.px)),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.network(
                                    chatDetail[i].image,
                                    width: 80.px,
                                    height: 80.px,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30.px,
                            )
                          ],
                        ),
              ],
            ),
          ),
          Container(
            width: 750.px,
            height: 100.px,
            padding: EdgeInsets.fromLTRB(20.px, 20.px, 20.px, 20.px),
            color: Colors.black12,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  height: 100.px,
                  color: Colors.white,
                  child: TextField(
                    controller: textEditingController,
                    scrollPadding: EdgeInsets.zero,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        border: InputBorder.none),
                  ),
                )),
                SizedBox(
                  width: 30.px,
                ),
                GestureDetector(
                  child: Icon(Icons.send),
                  onTap: () {
                    send();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
