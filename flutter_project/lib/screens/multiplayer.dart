import 'package:bot_toast/bot_toast.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbib_style/style/font_style.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:two_square_game/shared/components.dart/app_bar.dart';

import '../shared/components.dart/back_clicked.dart';
import '../shared/components.dart/custom_dialog.dart';
import '../shared/ads/my_banner_ad.dart';
import '../shared/cubit/multi_player_controller.dart';
import '../shared/cubit/states/muli_player_states.dart';
import 'menu.dart';

class MultiPlayer extends StatefulWidget {
  final int boardSize;
  final int numberOfPlayer;

  const MultiPlayer(this.boardSize, this.numberOfPlayer, {Key? key})
      : super(key: key);

  @override
  State<MultiPlayer> createState() => _MultiPlayerState();
}

class _MultiPlayerState extends State<MultiPlayer> with WidgetsBindingObserver {
  CountdownController cubitCountdownTimer =
      CountdownController(autoStart: true);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //Do whatever you want in background
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      MultiPlayercubit cubit = MultiPlayercubit.get(MultiPlayercubit.context!);
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
      create: (BuildContext context) => MultiPlayercubit(),
      child: Builder(
        builder: (context) {
          MultiPlayercubit cubit = MultiPlayercubit.get(context);
          MultiPlayercubit.context = context;
          Future.delayed(const Duration(milliseconds: 500)).then((value) {
            if (MultiPlayercubit.context == null) {
              cubit.logout();
            }
            cubit.makeOrJoinRoom(widget.boardSize, widget.numberOfPlayer);
          });

          return BlocConsumer<MultiPlayercubit, MultiPlyerStates>(
            listener: (BuildContext context, MultiPlyerStates state) async {
              if (state is UpdateGameAlert) {
                BotToast.showText(text: "Please Update Game");
                cubit.logout();
              } else if (state is ServerError) {
                BotToast.showText(text: "Server Error");
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Menu(),
                  ),
                  (route) => false,
                );
              } else if (state is YouCannotPlayHere) {
                BotToast.showText(text: "you can't play here");
              } else if (state is DrawGame) {
                BotToast.closeAllLoading();

                alertDialog(
                    title: 'Alert',
                    context: context,
                    meesage: "No one WIN the game",
                    multiplayer: true);
              } else if (state is EndGame) {
                BotToast.closeAllLoading();

                String info = cubit.playerLost == null
                    ? cubit.playerWin == 0
                        ? "No One Win The Game"
                        : cubit.playerWin == null
                            ? "Room issue"
                            : cubit.player() == cubit.playerWin
                                ? "You Win The Game"
                                : "You Lost The Game"
                    : cubit.playerLost != cubit.player()
                        ? "You Win The Game"
                        : "You Lost The Game";
                alertDialog(
                    title: 'Alert',
                    context: context,
                    meesage: info,
                    multiplayer: true);
              } else if (state is StartTime) {
                cubit.startTime(cubitCountdownTimer);
              } else if (state is StopTime) {
                cubit.stopTime(cubitCountdownTimer);
              } else if (state is RoomError) {
                BotToast.closeAllLoading();

                alertDialog(
                    title: 'Alert',
                    context: context,
                    meesage: "Room error",
                    multiplayer: true);
              } else if (state is FirebaseError) {
                BotToast.closeAllLoading();

                cubit.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Menu(),
                  ),
                  (route) => false,
                );
                BotToast.showText(text: "Try Again");
              }
            },
            builder: (BuildContext context, MultiPlyerStates state) {
              return WillPopScope(
                onWillPop: () async {
                  backClickedMultiPlayer(cubit, context);

                  return false;
                },
                child: Scaffold(
                  appBar: myAppBar("Choose 2 Squares - multiplayer",
                      multiplayer: true, cubit: cubit, context: context),
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BuildCondition(
                      condition:
                          state is! WaitingPlayer && cubit.idRoom() != null,
                      builder: (_) {
                        String turn = cubit.numberOfPlayer == 2
                            ? cubit.turn() == cubit.player()
                                ? "Your Turn"
                                : "Opponent's Turn"
                            : cubit.turn() == cubit.player()
                                ? "Your Turn"
                                : cubit.turn().toString();
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Builder(builder: (context) {
                                    return Countdown(
                                      controller: cubitCountdownTimer,
                                      onFinished: cubit.timeOut,
                                      build:
                                          (BuildContext context, double time) =>
                                              Text(
                                        " ${time.round()} ",
                                        style: TBIBFontStyle.b1,
                                      ),
                                      seconds: cubit.countdownTimerTurn,
                                    );
                                  }),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: Text(
                                      turn,
                                      style: TBIBFontStyle.b1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: GridView.count(
                                      shrinkWrap: true,
                                      crossAxisCount: widget.boardSize,
                                      childAspectRatio: 1,
                                      crossAxisSpacing: 1,
                                      children: [
                                        for (int i = 0;
                                            i < cubit.board.length;
                                            i++)
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: cubit.board[i] == "x"
                                                    ? const Color.fromRGBO(
                                                        182, 82, 81, .5)
                                                    : null,
                                              ),
                                              onPressed: cubit.turn() !=
                                                      cubit.player()
                                                  ? null
                                                  : cubit.number1() == i + 1
                                                      ? null
                                                      : () => cubit
                                                          .selectNumbers(i + 1),
                                              child: Text(
                                                  cubit.board[i].toString()),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            BuildCondition(
                              condition:
                                  cubit.adLoaded && MyBannerAd.adWidget != null,
                              builder: (_) => Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  width:
                                      MyBannerAd.myBanner.size.width.toDouble(),
                                  height: MyBannerAd.myBanner.size.height
                                      .toDouble(),
                                  child: MyBannerAd.adWidget,
                                ),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
