
import 'package:flutter/material.dart';
import 'package:flutter_im/page/chat_list_page.dart';
import 'package:flutter_im/util/adapt.dart';



void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Adapt.init();
    const title = 'WebSocket Demo';
    return const MaterialApp(
      title: title,
      home: ChatListPage(),
    );
  }
}


