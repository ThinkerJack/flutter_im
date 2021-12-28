import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im/util/adapt.dart';

/// @author wu chao
/// @project virtualchat
/// @date 2021/7/29
class CustomTheme {
  //extends InheritedWidget
  // CustomTheme({
  //   Key? key,
  //   required Widget child,
  // }) : super(key: key, child: child);

  final Color primaryColor = Colors.white;
  final Color backgroundColor = Color(0xFFF2F2F2);
  final Color alertColor = Colors.red;
  final TextStyle tabStyle = TextStyle(
      color: Colors.black, fontSize: 40.px, fontWeight: FontWeight.bold);
  final TextStyle bigTabStyle = TextStyle(
      color: Colors.black, fontSize: 55.px, fontWeight: FontWeight.bold);
  final TextStyle titleStyle = TextStyle(color: Colors.black, fontSize: 30.px);
  final TextStyle bigTitleStyle =
      TextStyle(color: Colors.black, fontSize: 40.px);
  final TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 30.px);
  final TextStyle secondTextStyle =
      TextStyle(color: Colors.black, fontSize: 24.px);
  final TextStyle grayTextStyle = TextStyle(
    color: Color.fromRGBO(188, 191, 191, 1),
    fontSize: 25.px,
  );
  final TextStyle bigGrayTextStyle = TextStyle(
    color: Color.fromRGBO(188, 191, 191, 1),
    fontSize: 30.px,
  );
  // static CustomTheme of(BuildContext context) {
  //   final CustomTheme? result =
  //       context.dependOnInheritedWidgetOfExactType<CustomTheme>();
  //   assert(result != null, 'No FrogColor found in context');
  //   return result!;
  // }
  //
  // @override
  // bool updateShouldNotify(CustomTheme old) => false;
}
