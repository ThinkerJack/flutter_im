/// @author wu chao
/// @project zjtc
/// @date 2021/12/7
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im/util/picker_method.dart';
import 'package:flutter_im/util/socket_manager.dart';
import 'package:flutter_im/util/socket_notifier.dart';
import 'package:flutter_im/model/user_model.dart';
import 'package:flutter_im/util/adapt.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../model/user_base.dart';
import '../model/chat.dart';
import '../util/database_manager.dart';


/// @author wu chao
/// @project zjtc
/// @date 2021/11/27
class ChatDetailVM extends ChangeNotifier {

  static final ChatDetailVM _instance = ChatDetailVM.internal();

  ChatDetailVM.internal();

  factory ChatDetailVM() => _instance;

  late Function listenFunc;

  late Timer timer;

  List<ChatDetail> chatDetail = [];

  late var function;

  TextEditingController textEditingController = TextEditingController();

  ScrollController scrollController = ScrollController();

  late User user;

  List<AssetEntity> assets = <AssetEntity>[];

  late DateTime firstDate;

  //上下拉刷新控制器
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  //分页限制
  int limit = 50;
  int count = 30;

  late UserBase userBase;

  init({vsync, required Function function, userBase, context}) {
    listenFunc = function;
    _instance.addListener(() {
      listenFunc();
    });
    this.userBase = userBase;
    //键盘关闭控制
    scrollController.addListener(() {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus!.unfocus();
      }
    });
    initData();
  }

  destruction() {
    _instance.removeListener(() {
      listenFunc();
    });
    leave();
  }
  leave(){
    timer.cancel();
    SocketManager().chatID = '';
    P2PNotifier().removeListener(function);
    SocketManager().leaveChat(userBase.id);
    DatabaseManager().selectChatListForID(userBase.id).then((chat) {
      ChatList newChat = ChatList(
          covId: Uuid().v1().replaceAll("-", ""),
          lastMsgText:
          chatDetail[0].type == -1 ? chatDetail[0].content : "[图片]",
          lastMsgAt: DateTime.now(),
          unreadCount: 0,
          image: userBase.image,
          name: userBase.name,
          sex: userBase.sex.toString(),
          chatObjectId: userBase.id);
      if (chat.length == 0) {
        DatabaseManager().insertChatList([newChat]);
      }
      if (chat.length != 0) {
        DatabaseManager().updateChatList(newChat);
      }
      P2PNotifier().notice();
    });
  }
  initData() async {
    getData();
    SocketManager().inChat(userBase.id);
    SocketManager().chatID = userBase.id;
    timer = Timer.periodic(Duration(seconds: 40), (timer) {
      SocketManager().inChat(userBase.id);
    });
    DatabaseManager().updateChatListUnread(userBase.id);
    SocketManager().getChatDetail(userBase.id);
    function = () {
      getData();
    };
    P2PNotifier().addListener(function);
    // SpUtil sp = await SpUtil.getInstance();
    // String? userString = sp.getString(SharedPreferencesKeys.user);
    // user = User.fromJson(jsonDecode(userString!));
  }

  getData() async {
    chatDetail =
        await DatabaseManager().selectChatDetail(userBase.id, limit: limit);
    notifyListeners();
  }

  send() {
    if (textEditingController.text != "") {
      String content = textEditingController.text;
      textEditingController.text = '';
      String msgID = Uuid().v1().replaceAll("-", "");
      ChatDetail chatDetail = ChatDetail(
        chatID: msgID,
        fromID: user.id,
        toID: userBase.id,
        content: content,
        createdAt: DateTime.now(),
        image: user.image,
        name: user.name,
        sex: user.sex.toString(),
        status: "wait",
        type: -1,
        chatObjectId: userBase.id,
      );
      DatabaseManager().insertChatDetail([chatDetail]).then((value) {
        getData();
        String talkData =
            '{"type": "cs_cp2p","payload": {"cd": {"data": {"attrs": {"MSG_TYPE": "SINGLE","USER_SEX": "${user.sex}","USER_ID": "${user.id}","USER_NAME": "${user.name}","USER_ICON": "${user.image}","CHAT_TIME": "${DateTime.now().millisecondsSinceEpoch}"},"text": "$content"},"mType": -1},"tid": "${userBase.id}"},"msg_id": "$msgID"}';
        SocketManager().talk(talkData);
      });
    }
  }

  onRefresh() async {
    limit = count;
    await getData();
    refreshController.refreshCompleted();
  }

  onLoading() async {
    limit += count;
    await getData();
    refreshController.loadComplete();
  }

  Widget getDate(i) {
    if (i == chatDetail.length - 1) {
      firstDate = chatDetail[i].createdAt.toLocal();
      return Padding(
        padding: EdgeInsets.only(bottom: 40.px, top: 0.px),
        child: Text(
          "${chatDetail[i].createdAt.toLocal().year}-${chatDetail[i].createdAt.toLocal().month}-${chatDetail[i].createdAt.toLocal().day} ${chatDetail[i].createdAt.toLocal().hour}:${chatDetail[i].createdAt.toLocal().minute.toString().padLeft(2, '0')}",
          style: TextStyle(color: Colors.black38),
        ),
      );
    }
    if (chatDetail[i].createdAt.toLocal().year ==
        chatDetail[i + 1].createdAt.toLocal().year) {
      if (chatDetail[i].createdAt.toLocal().month ==
          chatDetail[i + 1].createdAt.toLocal().month) {
        if (chatDetail[i].createdAt.toLocal().day ==
            chatDetail[i + 1].createdAt.toLocal().day) {
          if (chatDetail[i].createdAt.toLocal().hour ==
                  chatDetail[i + 1].createdAt.toLocal().hour &&
              ((chatDetail[i + 1].createdAt.toLocal().minute -
                      chatDetail[i].createdAt.toLocal().minute) <=
                  5)) {
            return SizedBox();
          }
          return Padding(
            padding: EdgeInsets.only(bottom: 40.px, top: 0.px),
            child: Text(
              "${chatDetail[i].createdAt.toLocal().hour}:${chatDetail[i].createdAt.toLocal().minute.toString().padLeft(2, '0')}",
              style: TextStyle(color: Colors.black38),
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.only(bottom: 40.px, top: 0.px),
          child: Text(
            "${chatDetail[i].createdAt.toLocal().month}-${chatDetail[i].createdAt.toLocal().day} ${chatDetail[i].createdAt.toLocal().hour}:${chatDetail[i].createdAt.toLocal().minute.toString().padLeft(2, '0')}",
            style: TextStyle(color: Colors.black38),
          ),
        );
      }
      return Padding(
        padding: EdgeInsets.only(bottom: 40.px, top: 0.px),
        child: Text(
          "${chatDetail[i].createdAt.toLocal().month}-${chatDetail[i].createdAt.toLocal().day} ${chatDetail[i].createdAt.toLocal().hour}:${chatDetail[i].createdAt.toLocal().minute.toString().padLeft(2, '0')}",
          style: TextStyle(color: Colors.black38),
        ),
      );
    }
    return SizedBox();
  }

  List<PickMethod> get pickMethods {
    return <PickMethod>[
      PickMethod.image(1),
      PickMethod.camera2(),
    ];
  }

  Future<void> selectAssets(BuildContext context, PickMethod model) async {
    final List<AssetEntity>? result = await model.method(context, assets);
    if (result != null) {
      assets = List<AssetEntity>.from(result);
      notifyListeners();
    }
  }

  List<String> get actions {
    return List.generate(
        pickMethods.length, (index) => pickMethods[index].name);
  }

  sendImage() async {
    // File? file = await assets[0].file;
    // var result;
    // try {
      // result = await HttpUtils.get(API_IMAGE_TOKEN, params: {
      //   "type": (user.id.compareTo(userBase.id) == -1)
      //       ? "chat/${user.id}${userBase.id}"
      //       : "chat/${userBase.id}${user.id}"
      // });
    // } catch (e) {
    //   print(e);
    // }
    //
    // Map<String, dynamic>? tokenData = result['data'];
    // late PutResponse data;
    // try {
    //   data = await QiNiuUtil.getInstance()
    //       .putChatFile(file!, token: tokenData!['token']);
    // } catch (e) {
    //   UICommon.toast('文件大小超出限制');
    //   return;
    // }
    // var decodedImage = await decodeImageFromList(file.readAsBytesSync());
    //
    // Image image = Image.file(file);
    // String content = data.rawData["url"];
    // //.replaceAll("-", "")
    // String msgID = Uuid().v1();
    // ChatDetail chatDetail = ChatDetail(
    //   chatID: msgID,
    //   fromID: user.id,
    //   toID: userBase.id,
    //   content: content,
    //   createdAt: DateTime.now(),
    //   image: user.image,
    //   name: user.name,
    //   sex: user.sex.toString(),
    //   status: "wait",
    //   type: -2,
    //   chatObjectId: userBase.id,
    // );
    // DatabaseManager().insertChatDetail([chatDetail]).then((value) {
    //   getData();
    //   String talkData =
    //       '''{"type": "cs_cp2p","payload": {"cd": {"mType": -2,"data": {"file": {"url": "${data.rawData["url"]}","oId": "${data.rawData["key"]}","meta": {"format": "image/jpeg","size": ${data.rawData["fsize"]},"height": ${decodedImage.height},"width": ${decodedImage.width}}},"text": "[图片]","attrs": {"USER_ICON": "${user.image}","CHAT_AT_ROOM_ID": "","SHOW_BIG_IMG": 0,"USER_NAME": "${user.name}","USER_ID": "${user.id}","USER_SEX": "${user.sex}","MSG_TYPE": "SINGLE"}}},"tid": "${userBase.id}"},"msg_id": "$msgID"}''';
    //   SocketManager().talk(talkData);
    // });
  }
}
