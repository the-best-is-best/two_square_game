import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:two_square_game/shared/components.dart/back_clicked.dart';

import '../controller/multi_player_controller.dart';

AppBar myAppBar(String title,
    {bool multiplayer = false,
    MultiPlayerController? cubit,
    BuildContext? context}) {
  return multiplayer == true
      ? AppBar(
          backgroundColor: HexColor("8c3839"),
          title: Text(title),
          leading: IconButton(
              onPressed: () {
                backClickedMultiPlayer(cubit!, context!);
              },
              icon: const Icon(Icons.arrow_back_rounded)),
        )
      : AppBar(
          backgroundColor: HexColor("8c3839"),
          title: Text(title),
        );
}
