import 'package:choose_two_squares/shared/components.dart/push_page.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tbib_dialog/tbib_dialog.dart';
import 'package:tbib_style/style/font_style.dart';

import '../../screens/game.dart';
import '../../screens/menu.dart';
import '../cubit/menu_controller.dart';

TBIBDialog alertDialog({
  required BuildContext context,
  required String title,
  required String meesage,
  bool multiplayer = false,
}) {
  return TBIBDialog(
    context: context,
    width: 520,
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
}) {
  return TBIBDialog(
    context: context,
    width: 520,
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

                    cubitMenu.playWithFriends = true;
                    if (cubitMenu.displayMode != "Easy") {
                      askManyPlayer(
                        context: context,
                        cubit: cubitMenu,
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

                    cubitMenu.playWithFriends = false;
                    if (cubitMenu.displayMode != "Easy") {
                      askManyPlayer(
                        context: context,
                        cubit: cubitMenu,
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
    width: 520,
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

                        cubit.numberOfPlayer = i + 2;
                        push(
                          context: context,
                          widget: Game(
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
