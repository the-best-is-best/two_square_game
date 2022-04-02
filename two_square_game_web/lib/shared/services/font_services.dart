import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tbib_style/style/font_style.dart';

import '../util/device_screen.dart';

void fontsServices() {
  if (DeviceType.isLargeScreen()) {
    TBIBFontStyle.h4 = TBIBFontStyle.h4.copyWith(fontWeight: FontWeight.w400);
    TBIBFontStyle.h3 = TBIBFontStyle.h3.copyWith(fontWeight: FontWeight.w600);
  }

  TBIBFontStyle.addCustomFont("SpaceMono", null);
  TBIBFontStyle.h4 = TBIBFontStyle.h4.copyWith(
    color: const Color.fromRGBO(206, 222, 235, .5),
  );
  TBIBFontStyle.h3 = TBIBFontStyle.h3.copyWith(
    color: const Color.fromRGBO(206, 222, 235, .5),
  );
  TBIBFontStyle.b1 = TBIBFontStyle.b1.copyWith(
    color: const Color.fromRGBO(206, 222, 235, .5),
  );

  TBIBFontStyle.h5 = TBIBFontStyle.h5.copyWith(
    color: const Color.fromRGBO(206, 222, 235, .5),
  );

  TBIBFontStyle.h6 = TBIBFontStyle.h5.copyWith(
    color: const Color.fromRGBO(206, 222, 235, .5),
  );
  log(TBIBFontStyle.h4.fontSize.toString());
}
