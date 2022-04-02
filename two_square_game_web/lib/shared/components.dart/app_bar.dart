import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tbib_style/style/font_style.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

AppBar myAppBar(String title,
    {bool multiplayer = false, required BuildContext context}) {
  return AppBar(
    backgroundColor: HexColor("8c3839"),
    title: Text(title, style: TBIBFontStyle.h4),
    actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            js.context.callMethod('open', [
              'https://play.google.com/store/apps/details?id=com.hardihood.two_square_game'
            ]);
          },
          child: Image.asset(
            "assets/img/google_play.png",
          ),
        ),
      )
    ],
  );
}
