import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tbib_style/style/font_style.dart';
import 'package:two_square_game/shared/components.dart/back_clicked.dart';

import '../cubit/multi_player_controller.dart';
import '../services/google_play/achivements.dart';
import '../services/google_play/leaderboard.dart';

AppBar myAppBar(String title,
    {bool menu = false,
    bool multiplayer = false,
    MultiPlayercubit? cubit,
    required BuildContext context}) {
  return menu == false
      ? multiplayer == true
          ? AppBar(
              backgroundColor: HexColor("8c3839"),
              title: Text(title, style: TBIBFontStyle.h6),
              leading: IconButton(
                  onPressed: () {
                    backClickedMultiPlayer(cubit!, context);
                  },
                  icon: const Icon(Icons.arrow_back_rounded)),
            )
          : AppBar(
              backgroundColor: HexColor("8c3839"),
              title: Text(title, style: TBIBFontStyle.h4),
            )
      : AppBar(
          backgroundColor: HexColor("8c3839"),
          title: Text(
            title,
            style: TBIBFontStyle.h6,
          ),
          actions: [
            IconButton(
              onPressed: () {
                openLeaderBoard();
              },
              icon: const FaIcon(
                FontAwesomeIcons.trophy,
                color: Color.fromRGBO(230, 150, 150, .5),
              ),
            ),
            IconButton(
              onPressed: () {
                openAchivement();
              },
              icon: const FaIcon(
                FontAwesomeIcons.medal,
                color: Color.fromRGBO(230, 150, 150, .5),
              ),
            )
          ],
        );
}
