import 'dart:developer';
import 'dart:ui';

class DeviceType {
  static double pixelRatio = window.devicePixelRatio;

  static final Size _logicalScreenSize = window.physicalSize / pixelRatio;
  static final double _logicalwidth = _logicalScreenSize.width;
  static final double _paddingLeft =
      window.padding.left / window.devicePixelRatio;
  static final double _paddingRight =
      window.padding.right / window.devicePixelRatio;
  static final double _safeWidth = _logicalwidth - _paddingLeft - _paddingRight;

  DeviceType() {
    log(_safeWidth.toString());
  }
  static bool isLargeScreen() {
    return _safeWidth >= 400 ? true : false;
  }

  static bool isMediumScreen() {
    return _safeWidth > 320 && _safeWidth < 400 ? true : false;
  }

  static bool isSmallScreen() {
    // 320px
    return _safeWidth <= 320 ? true : false;
  }
}
