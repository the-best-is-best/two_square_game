import 'package:bot_toast/bot_toast.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbib_style/tbib_style.dart';
import 'package:two_square_game/shared/controller/game_controller.dart';
import 'package:two_square_game/shared/states/game_states.dart';

import '../shared/components.dart/app_bar.dart';
import '../shared/components.dart/custom_dialog.dart';

class Game extends StatelessWidget {
  final int boardSize;
  const Game(this.boardSize, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('2 square game'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (BuildContext context) => GameController(),
          child: Builder(builder: (context) {
            GameController cubit = GameController.get(context);
            cubit.boardSize = boardSize;
            cubit.startGame();
            return BlocConsumer<GameController, GameStates>(
              listener: (BuildContext context, GameStates state) async {
                if (state is CannotPlayHere) {
                  BotToast.showText(
                      text: "you can't play here player: ${cubit.player}");
                }
                if (state is DrawGame) {
                  MessageDialog messageDialog = customDialog(
                      title: 'Alert',
                      context: context,
                      meesage: "No One Win The Game");

                  messageDialog.show(context);
                }
                if (state is WinGame) {
                  MessageDialog messageDialog = customDialog(
                      title: 'Alert',
                      context: context,
                      meesage: "player:  ${cubit.player} Win The Game");
                  messageDialog.show(context, barrierDismissible: false);
                }
              },
              builder: (BuildContext context, GameStates state) {
                return BuildCondition(
                  condition: !cubit.loading,
                  fallback: (context) => const Center(
                      child: CircularProgressIndicator(
                    color: Color.fromRGBO(206, 222, 235, .5),
                  )),
                  builder: (_) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Current Player ${cubit.player}",
                        style: TBIBFontStyle.b1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: boardSize,
                          childAspectRatio: 1,
                          crossAxisSpacing: 1,
                          children: [
                            for (int i = 0; i < cubit.board.length; i++)
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ElevatedButton(
                                  onPressed: cubit.number1() == i + 1
                                      ? null
                                      : () {
                                          cubit.selectNum(i + 1);
                                        },
                                  child: Text(cubit.board[i]),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}