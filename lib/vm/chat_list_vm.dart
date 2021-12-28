import 'package:flutter/cupertino.dart';
import 'package:flutter_im/util/socket_notifier.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../model/chat.dart';
import '../model/friends_model.dart';
import '../util/database_manager.dart';


/// @author wu chao
/// @project zjtc
/// @date 2021/12/1
class ChatListVM extends ChangeNotifier {
  static final ChatListVM _instance = ChatListVM.internal();

  ChatListVM.internal();

  factory ChatListVM() => _instance;

  late Function listenFunc;

  List<ChatList> chatList = [];

  //上下拉刷新控制器
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  //分页限制
  int limit = 10;
  int count = 10;

  FriendRequest? friendRequest;

  Map? followRequest;

  init({required Function function}) {
    listenFunc = function;
    _instance.addListener(() {
      listenFunc();
    });
    getData();
    getNotice();
    P2PNotifier().addListener(getData);
  }

  destruction() {
    _instance.removeListener(() {
      listenFunc();
    });
    P2PNotifier().removeListener(getData);
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

  getData() async {
    chatList = await DatabaseManager().selectChatList(limit: limit);
    notifyListeners();
  }

  deleteChatList({chatObjectID}) async {
    try {
      // await HttpUtils.post(API_P2P_REMOVE_LIST, params: {
      //   "user_ids": [chatObjectID]
      // });
    } catch (e) {}
    await DatabaseManager().deleteChatList(chatObjectID: chatObjectID);
    chatList = await DatabaseManager().selectChatList();
    notifyListeners();
  }

  getNotice() async {
    // SpUtil sp = await SpUtil.getInstance();
    var data;
    var friendRequestData;
    try {
      // data = await HttpUtils.get(API_FEED_COUNT, params: {
      //   "follower_sort": sp.getInt("followerSort") ?? 0,
      // });
      // friendRequestData =
      //     await HttpUtils.post(API_FRIEND_REQUEST_LIST, params: {
      //   "server_time": sp.getInt("friendRequestTime") ?? 0,
      //   "page": 0,
      // });
    } catch (e) {}
    if (data != null && data["data"] != null) {
      followRequest = data["data"][2];
      print(followRequest);
      notifyListeners();
    }
    if (friendRequestData != null && friendRequestData["data"] != null) {
      friendRequest = FriendRequest.fromJson(friendRequestData["data"]);
      print(friendRequest);
      notifyListeners();
    }
  }
}
