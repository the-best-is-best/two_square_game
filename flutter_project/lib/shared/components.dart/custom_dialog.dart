import 'dart:developer';

import 'package:dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:two_square_game/shared/components.dart/push_page.dart';

import '../../screens/menu.dart';

MessageDialog customDialog({
  required BuildContext context,
  required String title,
  required String meesage,
  bool multiplayer = false,
}) {
  return MessageDialog(
    title: title,
    titleColor: Colors.white,
    messageColor: Colors.white,
    message: meesage,
    dialogBackgroundColor: HexColor("8c3839"),
    buttonOkColor: const Color.fromRGBO(206, 222, 235, .5),
    buttonOkOnPressed: () {
      if (!multiplayer) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop();
        pushReplacementAll(widget: const Menu(), context: context);
      }
    },
  );
}