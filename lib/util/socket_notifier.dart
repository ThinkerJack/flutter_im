import 'package:flutter/cupertino.dart';

/// @author wu chao
/// @project flutter_im
/// @date 2021/8/14
class P2PNotifier extends ChangeNotifier {
  static final P2PNotifier _instance = P2PNotifier.internal();

  P2PNotifier.internal();

  factory P2PNotifier() => _instance;

  notice() {
    notifyListeners();
  }
}
