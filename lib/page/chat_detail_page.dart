
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im/util/adapt.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../model/user_base.dart';
import '../util/UI.dart';
import '../util/theme.dart';
import '../vm/chat_detail_vm.dart';

/// @author wu chao
/// @project flutter_im
/// @date 2021/8/16
class ChatDetailPage extends StatefulWidget {
  ChatDetailPage({Key? key, required this.userBase}) : super(key: key);
  UserBase userBase;

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  ChatDetailVM chatDetailVM = ChatDetailVM();

  @override
  void initState() {
    super.initState();
    chatDetailVM.init(
        vsync: this,
        function: () {
          setState(() {});
        },
        context: context,
        userBase: widget.userBase);
  }

  @override
  void dispose() {
    chatDetailVM.destruction();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
      backgroundColor: Color.fromRGBO(246, 249, 249, 1),
      appBar: AppBar(
          iconTheme: IconThemeData(
            size: 30.px,
          ),
          title: Text(
            widget.userBase.name,
            style: CustomTheme().titleStyle,
          ),
          backgroundColor:Colors.white,
          elevation: 0,
          actions: [
            UnconstrainedBox(
              child: Container(
                width: 130.px,
                height: 70.px,
                margin: EdgeInsets.only(right: 40.px),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60.px),
                  color: Color.fromRGBO(233, 138, 155, 1),
                ),
                alignment: Alignment.center,
                child: Text(
                  "关注",
                  style: TextStyle(color: Colors.white, fontSize: 25.px),
                ),
              ),
            ),
          ]),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: Column(
          children: [
            Expanded(
              child: SmartRefresher(
                enablePullDown: false,
                enablePullUp: true,
                header: WaterDropHeader(),
                controller: chatDetailVM.refreshController,
                // onRefresh: _onRefresh,
                onLoading: chatDetailVM.onLoading,
                child: ListView(
                  reverse: true,
                  controller: chatDetailVM.scrollController,
                  children: [
                    SizedBox(
                      height: 30.px,
                    ),
                    for (int i = 0;
                        i <= chatDetailVM.chatDetail.length - 1;
                        i++)
                      Column(
                        children: [
                          chatDetailVM.getDate(i),
                          (chatDetailVM.chatDetail[i].fromID ==
                                  chatDetailVM.chatDetail[i].chatObjectId)
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 30.px,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(90.px),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: Image.network(
                                            chatDetailVM.chatDetail[i].image,
                                            width: 80.px,
                                            height: 80.px,
                                          ),
                                        ),
                                        SizedBox(width: 20.px),
                                  if (chatDetailVM.chatDetail[i].type ==
                                            -2)
                                          Image.network(
                                            chatDetailVM.chatDetail[i].content,
                                            width: 300.px,
                                          ),
                                  if (chatDetailVM.chatDetail[i].type ==
                                            -1)
                                          Container(
                                            constraints: BoxConstraints(
                                              maxWidth: 560.px,
                                            ),
                                            padding: EdgeInsets.fromLTRB(
                                                20.px, 20.px, 20.px, 20.px),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topRight:
                                                    Radius.circular(90.px),
                                                bottomRight:
                                                    Radius.circular(90.px),
                                                bottomLeft:
                                                    Radius.circular(90.px),
                                              ),
                                              color: Colors.white,
                                            ),
                                            child: Text(
                                              "${chatDetailVM.chatDetail[i].content}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 30.px),
                                            ),
                                          ),
                                        // Text(
                                        //   "${chatDetail[i].status}",
                                        //   style: TextStyle(color: Colors.black),
                                        // ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 40.px,
                                    )
                                  ],
                                )
                              : Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // Text(
                                        //   "${chatDetail[i].status}",
                                        //   style: TextStyle(color: Colors.black),
                                        // ),
                                        if (chatDetailVM.chatDetail[i].type ==
                                            -2)
                                          Image.network(
                                            chatDetailVM.chatDetail[i].content,
                                            width: 300.px,
                                          ),
                                        if (chatDetailVM.chatDetail[i].type ==
                                            -1)
                                          Container(
                                            constraints: BoxConstraints(
                                              maxWidth: 560.px,
                                            ),
                                            padding: EdgeInsets.fromLTRB(
                                                20.px, 20.px, 20.px, 20.px),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(90.px),
                                                bottomRight:
                                                    Radius.circular(90.px),
                                                bottomLeft:
                                                    Radius.circular(90.px),
                                              ),
                                              color: Color.fromRGBO(
                                                  179, 153, 243, 1),
                                            ),
                                            child: Text(
                                              "${chatDetailVM.chatDetail[i].content}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 30.px),
                                            ),
                                          ),
                                        SizedBox(width: 20.px),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(90.px)),
                                          clipBehavior: Clip.antiAlias,
                                          child: Image.network(
                                            chatDetailVM.chatDetail[i].image,
                                            width: 80.px,
                                            height: 80.px,
                                          ),
                                        ),
                                        SizedBox(width: 30.px),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30.px,
                                    )
                                  ],
                                ),
                        ],
                      )
                  ],
                ),
              ),
            ),
            Container(
              width: 750.px,
              padding: EdgeInsets.fromLTRB(
                  25.px, 10.px, 20.px, 10.px + Adapt.padBotH),
              color: Colors.white,
              child: Row(
                children: [
                  GestureDetector(
                    child: Container(
                        width: 80.px,
                        height: 80.px,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(174, 142, 255, 1),
                            borderRadius: BorderRadius.circular(90.px)),
                        child: Icon(
                          Icons.image,
                          color: Colors.white,
                        )),
                    onTap: () {
                      UI.showActionSheet(context, chatDetailVM.actions, (i) {
                        chatDetailVM
                            .selectAssets(context, chatDetailVM.pickMethods[i])
                            .then((value) {
                          chatDetailVM.sendImage();
                        });
                      });
                    },
                  ),
                  SizedBox(
                    width: 30.px,
                  ),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20.px, 25.px, 0, 25.px),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(246, 249, 249, 1),
                        borderRadius: BorderRadius.circular(40.px)),
                    child: TextField(
                      controller: chatDetailVM.textEditingController,
                      scrollPadding: EdgeInsets.zero,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (data) {
                        chatDetailVM.send();
                      },
                      decoration: InputDecoration(
                          hintText: "输入新消息",
                          hintStyle:
                              TextStyle(color: Colors.black26, fontSize: 30.px),
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          border: InputBorder.none),
                    ),
                  )),
                  SizedBox(
                    width: 30.px,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
