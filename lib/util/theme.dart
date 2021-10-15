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
  final Color focusColor = Colors.black;
  final TextStyle titleStyle = TextStyle(
      color: Colors.black, fontSize: 40.px, fontWeight: FontWeight.bold);
  final TextStyle subTitleStyle =
      TextStyle(color: Colors.black, fontSize: 40.px);
  final TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 30.px);
  final TextStyle boldTextStyle = TextStyle(color: Colors.black, fontSize: 30.px,fontWeight: FontWeight.bold);
  final TextStyle secondTextStyle = TextStyle(
      color: Colors.black, fontSize: 24.px, fontWeight: FontWeight.bold);

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
