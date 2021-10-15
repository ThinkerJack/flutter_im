import 'package:flutter/material.dart';
import 'dart:ui';
extension IntFit on num {
  double get px {
    return Adapt.px(this);
  }

  double get py {
    return Adapt.py(this);
  }
}

//屏幕适配工具类
class Adapt {
  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
  static double _width = mediaQuery.size.width;
  static double _height = mediaQuery.size.height;
  static double _topbarH = mediaQuery.padding.top;
  static double _botbarH = mediaQuery.padding.bottom;
  static double _pixelRatio = mediaQuery.devicePixelRatio;

  /// AppBar 高度
  static double kToolbarHeight = 56.0;

  /// BottomNavigationBar 高度
  static double kBottomNavigationBarHeight = 56.0;

  /// 安全内容高度(包含 AppBar 和 BottomNavigationBar 高度)
  static double get safeContentHeight => _height - _topbarH - _botbarH;

  /// 实际的安全高度
  static double get safeHeight =>
      safeContentHeight - kToolbarHeight - kBottomNavigationBarHeight;

  static late double _ratio;
  static late double _ratioY;

  static init({int numberX = 750, int numberY = 1624}) {
    _ratio = _width / numberX;
    _ratioY = _height / numberY;
  }

  static double px(num number) {
    if (!(_ratio is double || _ratio is int)) {
      Adapt.init();
    }
    return number * _ratio;
  }

  static double py(num number) {
    if (!(_ratioY is double || _ratioY is int)) {
      Adapt.init();
    }
    return number * _ratioY;
  }

  static get screenW => _width;

  static get screenH => _height;

  static get padTopH => _topbarH;

  static get padBotH => _botbarH;
}
