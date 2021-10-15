import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_im/model/chat.dart';
import 'package:flutter_im/model/my_info.dart';
import 'package:flutter_im/page/chat_detail_page.dart';
import 'package:flutter_im/util/adapt.dart';
import 'package:flutter_im/util/database_manager.dart';
import 'package:flutter_im/util/socket_notifier.dart';
import 'package:flutter_im/util/theme.dart';

/// @author wu chao
/// @project flutter_im
/// @date 2021/8/12
class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late final function;
  List<ChatList> chatList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    getData();
    function = () {
      getData();
    };
    P2PNotifier().addListener(function);
  }

  getData() async {
    chatList = await DatabaseManager().selectChatList();
    setState(() {});
  }

  deleteChatList({chatObjectID}) async {
    Map<String, dynamic> optHeader = {
      'x-access-token': MyInfo.token,
    };
    Dio dio = Dio(BaseOptions(connectTimeout: 30000, headers: optHeader));
    var response = await dio.post(
        '',
        data: {
          "user_ids": [chatObjectID]
        });
    debugPrint(response.toString());
    if (response.data["code"] == 1000) {
      await DatabaseManager().deleteChatList(chatObjectID: chatObjectID);
      chatList = await DatabaseManager().selectChatList();
      setState(() {});
    }
  }

  @override
  void dispose() {
    P2PNotifier().removeListener(function);
    print("dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("消息列表"),
      ),
      body: ListView(
        children: [
          if (chatList != [])
            for (var chat in chatList)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailPage(
                          chatObjectId: chat.chatObjectId,
                          chatObjectImage: chat.image,
                          chatObjectSex: chat.sex,
                          chatObjectName: chat.name,
                        ),
                      )).then((value) {
                    getData();
                  });
                },
                child: Container(
                  height: 150.px,
                  child: ListView(
                    key: UniqueKey(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        width: Adapt.px(750),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 3.px, //宽度
                              color: CustomTheme().backgroundColor, //边框颜色
                            ),
                          ),
                          color: CustomTheme().primaryColor,
                        ),
                        padding:
                            EdgeInsets.fromLTRB(20.px, 20.px, 20.px, 20.px),
                        child: Row(
                          children: [
                            Container(
                              width: 100.px,
                              height: 100.px,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(90.px)),
                              clipBehavior: Clip.antiAlias,
                              child: Image.network(chat.image),
                            ),
                            SizedBox(width: 10.px),
                            Container(
                              width: 450.px,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    chat.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: CustomTheme().titleStyle,
                                  ),
                                  Text(
                                    chat.lastMsgText,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: CustomTheme().textStyle,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.px),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                      "${chat.lastMsgAt.year}/${chat.lastMsgAt.month}/${chat.lastMsgAt.day}"),
                                  SizedBox(
                                    height: 10.px,
                                  ),
                                  Visibility(
                                    visible: chat.unreadCount != 0,
                                    child: Container(
                                      width: 40.px,
                                      height: 40.px,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(90),
                                        color: Colors.red,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        chat.unreadCount.toString(),
                                        style: TextStyle(
                                            color: CustomTheme().primaryColor,
                                            fontSize: 25.px),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          deleteChatList(chatObjectID: chat.chatObjectId);
                        },
                        child: Container(
                          width: 140.px,
                          alignment: Alignment.center,
                          color: Colors.red,
                          child: Text(
                            "删除",
                            style: TextStyle(color: CustomTheme().primaryColor),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
        ],
      ),
    );
  }
}
