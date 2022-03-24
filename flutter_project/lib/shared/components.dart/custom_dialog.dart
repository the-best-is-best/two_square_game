import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tbib_dialog/tbib_dialog.dart';
import 'package:tbib_style/tbib_style.dart';
import 'package:two_square_game/screens/game.dart';
import 'package:two_square_game/screens/multiplayer.dart';
import 'package:two_square_game/shared/components.dart/push_page.dart';
import 'package:two_square_game/shared/cubit/game_controller.dart';
import 'package:two_square_game/shared/cubit/menu_controller.dart';
import 'package:two_square_game/shared/cubit/multi_player_controller.dart';

import '../../screens/menu.dart';
import '../ads/interstitial_ad.dart';
import '../ads/my_banner_ad.dart';

TBIBDialog alertDialog({
  required BuildContext context,
  required String title,
  required String meesage,
  bool multiplayer = false,
}) {
  return TBIBDialog(
    context: context,
    animType: AnimType.SCALE,
    customHeader: const CircleAvatar(
      backgroundColor: Color.fromRGBO(182, 82, 81, 1),
      radius: 50,
      child: Icon(
        Icons.info_outlined,
        color: Colors.white,
        size: 50,
      ),
    ),
    dialogBackgroundColor: HexColor("8c3839"),
    dismissOnBackKeyPress: false,
    dismissOnTouchOutside: false,
    body: Center(
      child: SizedBox(
        height: 86,
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Text(
              title,
              style: TBIBFontStyle.h5,
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Text(
              meesage,
              style: TBIBFontStyle.h5,
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          ],
        ),
      ),
    ),
    title: title,
    desc: meesage,
    btnOkColor: const Color.fromRGBO(206, 222, 235, .5),
    btnOkOnPress: () {
      if (!multiplayer) {
        Navigator.of(context).pop();
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const Menu(),
          ),
          (route) => false,
        );
      }
    },
  )..show();
}

TBIBDialog askManyPlayer({
  required BuildContext context,
  required String gameMode,
  required Menucubit cubit,
  Gamecubit? cubitGame,
  MultiPlayercubit? cubitMulti,
  bool isMulti = false,
}) {
  log(cubit.boardSize.toString());
  int buttonsPlayerSelector = 2;
  switch (gameMode) {
    case "Medium":
      buttonsPlayerSelector = 2;
      break;

    case "Hard":
      buttonsPlayerSelector = 3;
      break;
  }
  return TBIBDialog(
    context: context,
    animType: AnimType.SCALE,
    customHeader: const CircleAvatar(
      backgroundColor: Color.fromRGBO(182, 82, 81, 1),
      radius: 50,
      child: Icon(
        Icons.question_mark,
        color: Colors.white,
        size: 50,
      ),
    ),
    dialogBackgroundColor: HexColor("8c3839"),
    showCloseIcon: true,
    closeIcon: const Icon(Icons.close_rounded, color: Colors.white),
    body: Center(
      child: SizedBox(
        height: 155,
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            Text(
              'How many players?',
              style: TBIBFontStyle.h5,
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < buttonsPlayerSelector; i++)
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        MyInterstitial.getAd();
                        MyBannerAd.checkAdLoaded();
                        push(
                          context: context,
                          widget: isMulti
                              ? MultiPlayer(cubit.boardSize, i + 2)
                              : Game(cubit.boardSize, i + 2),
                        );
                      },
                      child: Text((i + 2).toString()))
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          ],
        ),
      ),
    ),
  )..show();
}
