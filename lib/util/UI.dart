import 'package:flutter/cupertino.dart';

import 'bottom_sheet.dart';

/// @author wu chao
/// @project zjtc
/// @date 2021/12/6
class UI{
  static showActionSheet(
      BuildContext context, List<String> menus, Function(int) callback,
      {String? title}) {
    BottomActionSheet.show(context, menus, callback, title: title);
  }
}