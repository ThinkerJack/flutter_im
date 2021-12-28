/// @author wu chao
/// @project virtualchat
/// @date 2021/8/20
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im/util/adapt.dart';

import 'theme.dart';


/// @author wu chao
/// @project virtualchat
/// @date 2021/8/20
class FriendItem extends StatelessWidget {
  const FriendItem(
      {Key? key,
        required this.id,
        required this.name,
        required this.image,
        required this.signature,
        required this.tap})
      : super(key: key);
  final String id;
  final String image;
  final String name;
  final String signature;
  final Function tap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        tap();
      },
      child: Container(
        width: 710.px,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 3.px, //宽度
              color: CustomTheme().backgroundColor, //边框颜色
            ),
          ),
          color: CustomTheme().primaryColor,
        ),
        margin: EdgeInsets.symmetric(horizontal: 20.px),
        padding: EdgeInsets.fromLTRB(40.px, 40.px, 40.px, 40.px),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100.px,
              height: 100.px,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(90.px)),
              clipBehavior: Clip.antiAlias,
              child: Image.network(image),
              // ??
              // "https://werewolf-image.xiaobanhui.com/default/male_wolf.png?imageView2%2F0%2Fw%2F1920%2Fh%2F1080%2Fq%2F75%7Cimageslim"
            ),
            SizedBox(width: 40.px),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2.px,
                  ),
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTheme().titleStyle,
                  ),
                  SizedBox(
                    height: 20.px,
                  ),
                  Text(
                    signature,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTheme().grayTextStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  const ChatItem(
      {Key? key,
      required this.name,
      required this.sex,
      required this.image,
      required this.lastMsgText,
      required this.lastMsgAt,
      required this.unreadCount,
      required this.onDelete,
      required this.tap})
      : super(key: key);
  final String image;
  final String name;
  final String sex;
  final String lastMsgText;
  final Function tap;
  final Function onDelete;
  final DateTime lastMsgAt;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    print(sex);
    return GestureDetector(
      onTap: () {
        tap();
      },
      child: Container(
        height: 190.px,
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
              padding: EdgeInsets.fromLTRB(40.px, 0.px, 40.px, 0.px),
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 110.px,
                        height: 110.px,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90.px)),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(image),
                      ),
                      Positioned(
                        right: -5.px,
                        top: -5.px,
                        child: Visibility(
                          visible: unreadCount != 0,
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
                              unreadCount.toString(),
                              style: TextStyle(
                                  color: CustomTheme().primaryColor,
                                  fontSize: 23.px),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(width: 40.px),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: CustomTheme().bigTitleStyle,
                            ),
                            SizedBox(
                              width: 20.px,
                            ),
                            sex == "1"
                                ? Icon(
                                    Icons.male,
                                    size: 30.px,
                                    color: Colors.blue,
                                  )
                                : Icon(
                                    Icons.female,
                                    size: 30.px,
                                    color: Color.fromRGBO(251, 182, 222, 1),
                                  )
                          ],
                        ),
                        SizedBox(
                          height: 15.px,
                        ),
                        Text(
                          lastMsgText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTheme().bigGrayTextStyle,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 40.px),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 10.px,
                        ),
                        Text(
                          "${lastMsgAt.month}-${lastMsgAt.day}",
                          style: CustomTheme().grayTextStyle,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                onDelete();
              },
              child: Container(
                width: 140.px,
                alignment: Alignment.center,
                color: CustomTheme().alertColor,
                child: Text(
                  "删除",
                  style: TextStyle(color: CustomTheme().primaryColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
