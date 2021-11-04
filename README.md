![](https://img-blog.csdnimg.cn/20211015185505683.png)

# 1. 即时通讯简述

即时通讯是端开发工作中常见的需求，本篇文章以作者工作中使用FLutter开发社交软件即时通讯需求为背景，描述一下即时通讯功能设计的要点。

# 2. 重要概念

即时通讯需要前后端配合，约定消息格式与消息内容。本次IM客户端需求开发使用了公司已有的基于Socket.io搭建的后台，下文描述涉及到的一些概念。

## 2.1 WebSocket协议

WebSocket是一种在单个TCP连接上进行全双工通信的协议。WebSocket协议与传统的HTTP协议的主要区别为，WebSocket协议允许服务端主动向客户端推送数据，而传统的HTTP协议服务器只有在客户端主动请求之后才能向客户端发送数据。在没有WebSocket之前，即时通讯大部分采用长轮询方式。

## 2.2 Socket.io和WebSocket的区别

Socket.io不是WebSocket，它只是将WebSocket和轮询 （Polling）机制以及其它的实时通信方式封装成了通用的接口，并且在服务端实现了这些实时机制的相应代码。也就是说，WebSocket仅仅是Socket.io实现即时通信的一个子集。因此WebSocket客户端连接不上Socket.io服务端，当然Socket.io客户端也连接不上WebSocket服务端。

## 2.3 服务端socket消息

理解了服务端socket消息也就理解了服务器端的即时通讯逻辑，服务器发出的socket消息可以分为两种：

1. 服务器主动发出的消息：

   例如，社交软件中的A用户给B用户发出了消息，服务器在收到A用户的消息后，通过socket链接，将A用户的消息转发给B用户，B用户客户端接收到的消息就属于服务器主动发出的。其他比较常见的场景例如直播软件中，全平台用户都会收到的礼物消息广播。

2. 服务器在接收到客户端消息后的返回消息：

   例如，长链接心跳机制，客户端向服务器发送ping消息，服务器在成功接受客户端的ping消息后返回的pong消息就属于服务器的返回消息。其他常见的场景如社交软件中A用户给B用户发出了消息，服务器在收到A用户的消息后，给A客户端返回一条消息，供A客户端了解消息的发送状态，判断发送是否成功。大部分场景，服务器在接收到客户端主动发出的消息之后都需要返回一条消息。

# 3. 客户端实现流程

几个设计客户端即时通讯的重点。

## 3.1 心跳机制

所谓心跳就是客户端发出ping消息，服务器成功收到后返回pong消息。当客户端一段时间内不在发送ping消息，视为客户端断开，服务器就会主动关闭socket链接。当客户端发送ping消息，服务器一段时间内没有返回pong消息，视为服务器断开，客户端就会启动重连机制。

![启动流程](https://img-blog.csdnimg.cn/20211015185505866.png)

## 3.2 重连机制

重连机制为客户端重新发起连接，常见的重连条件如下：

- 客户端发送ping消息，服务器一段时间内没有返回pong。
- 客户端网络断开。
- 服务器主动断开连接。
- 客户端主动连接失败。

当出现极端情况（客户端断网）时，频繁的重连可能会导致资源的浪费，可以设置一段时间内的最大重连次数，当重连超过一定次数时，休眠一段时间。

## 3.3 消息发送流程

1. 将消息存储到本地数据库，发送状态设为等待。
2. 发送socket消息。
3. 接收到服务器返回的socket消息后，将本地数据库等待状态的消息改为成功。

注意事项：

将消息存储到本地数据库时需要生成一个id存入数据库，同时传给服务器，当收到消息时根据id判断更新本地数据库的哪一条消息。

## 3.4 消息接收流程

![](https://img-blog.csdnimg.cn/2021101518550635.png)

## 3.5 其他相关

- 聊天页消息的排序：在查询本地数据库时使用`order by`按时间排序。
- 消息列表：也推荐做本地存储，当收到消息的时候需要先判断本地消息列表是否有当前消息用户的对话框，如果没有就先插入，有就更新。消息列表的维护就不展开说了，感兴趣可以看代码。
- 图片语音消息：将图片和语言先上传到专门的服务器上（各种专门的云存储服务器），sokcet消息和本地存储传递的是云服务器上的URL。
- 多人聊天（群聊）：与单人聊天逻辑基本一致，区别位本地数据库需要添加一个会话ID字段，打开一个群就查询对应会话ID的数据。聊天消息不再是谁发给谁，而是在哪个群聊下。

# 4. 客户端Flutter代码

把部分代码贴上来，完整项目在作者的[github](https://github.com/ThinkerJack/flutter_im)上。

## 4.1 心跳机制

```dart
  heart() {
    pingTimer = Timer.periodic(Duration(seconds: 30), (data) {
      if (pingWaitTime >= 60) {
        socket.connect();
        pingWaitTime = 0;
        pingWaitTimer!.cancel();
        ping();
      }
      if (!pingWaitFlag) ping();
    });
  }

  ping() {
    debugPrint("ping");
    String pingData =
        '{"type":"ping","payload":{"front":true},"msg_id":${DateTime.now().millisecondsSinceEpoch}}';
    socket.emit("message", pingData);
    pingWaitFlag = true;
    pingWaitTime = 0;
    pingWaitTimer = Timer.periodic(Duration(seconds: 1), (data) {
      pingWaitTime++;
      print(data.hashCode);
      if (pingWaitTime % 10 == 0) debugPrint(pingWaitTime.toString());
    });
  }
	//pong
  if (socketMessage.type == PONG && socketMessage.code == 1000) {
        pingWaitFlag = false;
        pingWaitTimer!.cancel();
        pingWaitTime = 0;
      }
```

## 4.2 本地数据库设计

数据库表的设计是比较重要的，理解了数据库设计，读代码也就无压力了。

```sql
      //消息表
      CREATE TABLE chatDetail (
         chat_id TEXT PRIMARY KEY,//主键
         from_id TEXT,//发送人
         to_id TEXT,//接收人
         created_at TEXT,
         content TEXT,//消息内容
         image TEXT,//UI展示用，用户头像
         name TEXT,//UI展示用，用户名
         sex TEXT,//UI展示用，用户性别
         status TEXT,//消息状态
         type INTEGER,//消息类型，图片/文字/语音等
         chat_object_id TEXT//聊天对象ID，对当前用户而言的聊天对象，是一系列本地操作的核心
         )
       //消息列表表
       CREATE TABLE chatList (
         cov_id TEXT,
         unread_count INTEGER,
         last_msg_text TEXT,
         last_msg_at TEXT,
         image TEXT,
         name TEXT,
         sex TEXT,
         chat_object_id TEXT PRIMARY KEY)
```

# 5. 总结

无论是Flutter技术，或是IOS/Android/Web。只要掌握了即时通讯的核心开发流程，不同的技术只是API有些变化。API往往看文档就能解决，大前端或是特定平台的工程师还是要掌握核心开发流程，会几种做同样事情的API意义不大。

demo写的比较简单，有问题可以评论。

[项目github地址](https://github.com/ThinkerJack/flutter_im)

![](https://img-blog.csdnimg.cn/c66cc07b674c424ba11ec6825e22a640.png)

![](https://img-blog.csdnimg.cn/46f9ed15f914479ab130d47e9578e721.png)
