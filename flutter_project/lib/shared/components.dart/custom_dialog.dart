import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tbib_dialog/tbib_dialog.dart';
import 'package:tbib_style/style/font_style.dart';
import 'package:two_square_game/shared/components.dart/push_page.dart';

import '../../screens/game.dart';
import '../../screens/menu.dart';
import '../../screens/multiplayer.dart';
import '../ads/interstitial_ad.dart';
import '../ads/my_banner_ad.dart';
import '../cubit/menu_controller.dart';

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

TBIBDialog askQuestions({
  required BuildContext context,
  required Menucubit cubitMenu,
  bool isMulti = false,
}) {
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
    closeIcon: const Icon(
      Icons.close_rounded,
      color: Colors.white,
    ),
    body: Center(
      child: SizedBox(
        height: 155,
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            Text(
              'Play with friends?',
              style: TBIBFontStyle.h5,
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    MyInterstitial.getAd();
                    MyBannerAd.checkAdLoaded();
                    cubitMenu.playWithFriends = true;
                    if (cubitMenu.displayMode != "Easy") {
                      askManyPlayer(
                        context: context,
                        cubit: cubitMenu,
                        isMulti: isMulti,
                      );
                    } else {
                      push(
                          widget: Game(
                            boardSize: cubitMenu.boardSize,
                            playWithFriends: cubitMenu.playWithFriends,
                            numberOfPlayer: 2,
                          ),
                          context: context);
                    }
                  },
                  child: const Text("Yes"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    MyInterstitial.getAd();
                    MyBannerAd.checkAdLoaded();
                    cubitMenu.playWithFriends = false;
                    if (cubitMenu.displayMode != "Easy") {
                      askManyPlayer(
                        context: context,
                        cubit: cubitMenu,
                        isMulti: isMulti,
                      );
                    } else {
                      push(
                          widget: Game(
                            boardSize: cubitMenu.boardSize,
                            playWithFriends: cubitMenu.playWithFriends,
                            numberOfPlayer: 2,
                          ),
                          context: context);
                    }
                  },
                  child: const Text("No"),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          ],
        ),
      ),
    ),
  )..show();
}

TBIBDialog askManyPlayer({
  required BuildContext context,
  required Menucubit cubit,
  bool isMulti = false,
}) {
  int buttonsPlayerSelector = 2;
  switch (cubit.displayMode) {
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
                        cubit.numberOfPlayer = i + 2;
                        push(
                          context: context,
                          widget: isMulti
                              ? MultiPlayer(cubit.boardSize, i + 2)
                              : Game(
                                  boardSize: cubit.boardSize,
                                  numberOfPlayer: cubit.numberOfPlayer,
                                  playWithFriends: cubit.playWithFriends,
                                ),
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
