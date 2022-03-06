import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:dialogs/dialogs/message_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbib_style/style/font_style.dart';
import 'package:two_square_game/shared/components.dart/app_bar.dart';
import 'package:two_square_game/shared/controller/multi_player_controller.dart';
import 'package:two_square_game/shared/states/muli_player_states.dart';

import '../shared/components.dart/custom_dialog.dart';

class MultiPlayer extends StatefulWidget {
  final int boardSize;

  const MultiPlayer(this.boardSize, {Key? key}) : super(key: key);

  @override
  State<MultiPlayer> createState() => _MultiPlayerState();
}

class _MultiPlayerState extends State<MultiPlayer> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //Do whatever you want in background
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      MultiPlayerController cubit =
          MultiPlayerController.get(MultiPlayerController.context!);
      cubit.logout();
    }
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MultiPlayerController(),
      child: Builder(
        builder: (context) {
          MultiPlayerController cubit = MultiPlayerController.get(context);
          MultiPlayerController.context = context;
          cubit.makeOrJoinRoom(widget.boardSize);
          return BlocConsumer<MultiPlayerController, MultiPlyerStates>(
            listener: (BuildContext context, MultiPlyerStates state) async {
              if (state is ServerError) {
                Navigator.pop(context);
              }
              if (state is YouCannotPlayHere) {
                BotToast.showText(text: "you can't play here");
              }
              if (state is DrawGame) {
                MessageDialog messageDialog = customDialog(
                    title: 'Alert',
                    context: context,
                    meesage: "No one WIN the game",
                    multiplayer: true);

                messageDialog.show(context, barrierDismissible: true);
              }
              if (state is EndGame) {
                String info = cubit.playerWin == 0
                    ? "No One Win The Game"
                    : cubit.player() == cubit.playerWin
                        ? "You Win The Game"
                        : "You Lost The Game";
                MessageDialog messageDialog = customDialog(
                    title: 'Alert',
                    context: context,
                    meesage: info,
                    multiplayer: true);
                messageDialog.show(context, barrierDismissible: true);
              }
            },
            builder: (BuildContext context, MultiPlyerStates state) {
              return Scaffold(
                appBar: myAppBar("2 Square Game - multiplayer",
                    multiplayer: true, cubit: cubit, context: context),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BuildCondition(
                    condition: state is! WaitingPlayer,
                    builder: (_) {
                      String turn = cubit.turn() == cubit.player()
                          ? "Your Turn"
                          : "Opponent's Turn";
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            turn,
                            style: TBIBFontStyle.b1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: widget.boardSize,
                              childAspectRatio: 1,
                              crossAxisSpacing: 1,
                              children: [
                                for (int i = 0; i < cubit.board.length; i++)
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ElevatedButton(
                                      onPressed: cubit.turn() != cubit.player()
                                          ? null
                                          : cubit.number1() == i + 1
                                              ? null
                                              : () =>
                                                  cubit.selectNumbers(i + 1),
                                      child: Text(cubit.board[i].toString()),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    fallback: (_) => Center(
                      child: Text(
                        "Waiting Another Player",
                        style: TBIBFontStyle.b1,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
