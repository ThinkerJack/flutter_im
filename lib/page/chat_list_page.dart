import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im/util/adapt.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../util/theme.dart';
import '../util/chat_item.dart';
import '../vm/chat_list_vm.dart';

/// @author wu chao
/// @project flutter_im
/// @date 2021/8/12
class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {

  ChatListVM chatListVM = ChatListVM();

  @override
  void initState() {
    super.initState();
    chatListVM.init(function: () {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    chatListVM.destruction();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      controller: chatListVM.refreshController,
      onRefresh: chatListVM.onRefresh,
      onLoading: chatListVM.onLoading,
      child: ListView(
        children: [
          GestureDetector(
            onTap: () async {
              // NavigatorUtil.push("systemMessage");
            },
            child: Container(
              width: 750.px,
              height: 160.px,
              padding: EdgeInsets.fromLTRB(40.px, 10.px, 20.px, 10.px),
              decoration: BoxDecoration(
                color: CustomTheme().primaryColor,
              ),
              child: Row(
                children: [
                  Container(
                    height: 110.px,
                    width: 110.px,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90.px),
                      color: Color.fromRGBO(126, 119, 244, 1),
                    ),
                    child: Icon(
                      Icons.add_alert_rounded,
                      color: Colors.white,
                      size: 55.px,
                    ),
                  ),
                  SizedBox(
                    width: 50.px,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "通知",
                        style: CustomTheme().bigTitleStyle,
                      ),
                      SizedBox(
                        height: 15.px,
                      ),
                      Text(
                        "暂无通知",
                        style: CustomTheme().bigGrayTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              // NavigatorUtil.push("newFans");
            },
            child: Container(
              width: 750.px,
              height: 160.px,
              padding: EdgeInsets.fromLTRB(40.px, 10.px, 20.px, 10.px),
              decoration: BoxDecoration(
                color: CustomTheme().primaryColor,
              ),
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 110.px,
                        width: 110.px,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90.px),
                          color: Color.fromRGBO(101, 137, 242, 1),
                        ),
                        child: Icon(
                          Icons.attribution,
                          color: Colors.white,
                          size: 55.px,
                        ),
                      ),
                      Positioned(
                        right: -5.px,
                        top: -5.px,
                        child: Visibility(
                          visible: chatListVM.followRequest != null &&
                              chatListVM.followRequest!["count"] != 0,
                          // visible: true,
                          child: Container(
                            width: 40.px,
                            height: 40.px,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                color: CustomTheme().alertColor,
                                border: Border.all(
                                    color: Colors.white, width: 3.px)),
                            alignment: Alignment.center,
                            child: Text(
                              "${chatListVM.followRequest != null ? chatListVM.followRequest!["count"].toString() : "0"}",
                              style: TextStyle(
                                  color: CustomTheme().primaryColor,
                                  fontSize: 23.px),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 50.px,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "关注",
                        style: CustomTheme().bigTitleStyle,
                      ),
                      SizedBox(
                        height: 15.px,
                      ),
                      Text(
                        "${(chatListVM.followRequest != null && chatListVM.followRequest!["count"] != 0) ? "有${chatListVM.followRequest!["count"]}位朋友关注了你" : "暂无通知"}",
                        style: CustomTheme().bigGrayTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              // NavigatorUtil.push("friendRequest");
            },
            child: Container(
              width: 750.px,
              height: 160.px,
              padding: EdgeInsets.fromLTRB(40.px, 10.px, 20.px, 10.px),
              decoration: BoxDecoration(
                color: CustomTheme().primaryColor,
              ),
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 110.px,
                        width: 110.px,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90.px),
                            color: Color.fromRGBO(244, 133, 173, 1)),
                        child: Icon(
                          Icons.account_circle_outlined,
                          color: Colors.white,
                          size: 55.px,
                        ),
                      ),
                      Positioned(
                        right: -5.px,
                        top: -5.px,
                        child: Visibility(
                          visible: chatListVM.friendRequest != null &&
                              chatListVM.friendRequest?.updateCount != 0,
                          // visible: true,
                          child: Container(
                            width: 40.px,
                            height: 40.px,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                color: CustomTheme().alertColor,
                                border: Border.all(
                                    color: Colors.white, width: 3.px)),
                            alignment: Alignment.center,
                            child: Text(
                              "${chatListVM.friendRequest?.updateCount ?? ""}",
                              style: TextStyle(
                                  color: CustomTheme().primaryColor,
                                  fontSize: 23.px),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 50.px,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "好友请求",
                        style: CustomTheme().bigTitleStyle,
                      ),
                      SizedBox(
                        height: 15.px,
                      ),
                      Text(
                        "${(chatListVM.friendRequest != null && chatListVM.friendRequest!.updateCount != 0) ? "有${chatListVM.friendRequest!.updateCount}位陌生人请求添加你为好友" : "暂无通知"}",
                        style: CustomTheme().bigGrayTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (chatListVM.chatList != [])
            for (var chat in chatListVM.chatList)
              ChatItem(
                tap: () {
                  // NavigatorUtil.push(
                  //   "chatDetailPage",
                  //   arguments: {
                  //     "userBase": UserBase(
                  //         id: chat.chatObjectId,
                  //         sex: int.parse(chat.sex),
                  //         name: chat.name,
                  //         image: chat.image)
                  //   },
                  // ).then((value) {
                  //   chatListVM.getData();
                  // });
                },
                name: chat.name,
                image: chat.image,
                lastMsgAt: chat.lastMsgAt,
                lastMsgText: chat.lastMsgText,
                unreadCount: chat.unreadCount,
                sex:chat.sex,
                onDelete: () {
                  chatListVM.deleteChatList(chatObjectID: chat.chatObjectId);
                },
              ),
        ],
      ),
    );
  }
}
