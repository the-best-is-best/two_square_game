import 'dart:developer';
import 'dart:ui';

class DeviceIsTablet {
  static bool isTablet() {
    double pixelRatio = window.devicePixelRatio;

    // size in phusical
    Size physicalScreenSize = window.physicalSize;
    double physicalwidth = physicalScreenSize.width;
    double physicalheight = physicalScreenSize.height;

    Size logicalScreenSize = window.physicalSize / pixelRatio;
    double logicalwidth = logicalScreenSize.width;
    double logicalheight = logicalScreenSize.height;

    WindowPadding padding = window.padding;

    double paddingLeft = window.padding.left / window.devicePixelRatio;
    double paddingRight = window.padding.right / window.devicePixelRatio;
    double paddingTop = window.padding.top / window.devicePixelRatio;
    double paddingBottom = window.padding.bottom / window.devicePixelRatio;

    double safeWidth = logicalwidth - paddingLeft - paddingRight;
    double safeHeight = logicalheight - paddingTop - paddingBottom;
    log(safeWidth.toString());
    return safeWidth > 560 ? true : false;
  }
}
