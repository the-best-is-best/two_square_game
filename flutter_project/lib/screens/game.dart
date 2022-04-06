import 'package:bot_toast/bot_toast.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbib_style/tbib_style.dart';

import '../shared/components.dart/app_bar.dart';
import '../shared/components.dart/custom_dialog.dart';
import '../shared/ads/my_banner_ad.dart';
import '../shared/cubit/game_controller.dart';
import '../shared/cubit/states/game_states.dart';

class Game extends StatefulWidget {
  final int boardSize;
  final int numberOfPlayer;
  final bool playWithFriends;

  const Game({
    Key? key,
    required this.boardSize,
    required this.playWithFriends,
    required this.numberOfPlayer,
  }) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('Choose 2 Squares', context: context),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocProvider(
          create: (BuildContext context) => Gamecubit(),
          child: Builder(builder: (context) {
            Gamecubit cubit = Gamecubit.get(context);
            cubit.boardSize = widget.boardSize;
            cubit.startGame(
              sendBoard: widget.boardSize,
              withFriend: widget.playWithFriends,
              numOfPlayer: widget.numberOfPlayer,
            );
            return BlocConsumer<Gamecubit, GameStates>(
              listener: (BuildContext context, GameStates state) async {
                if (state is CannotPlayHere) {
                  BotToast.showText(
                      text: cubit.playWithFriends
                          ? "you can't play here player: ${cubit.player}"
                          : "you can't play here ");
                }
                if (state is DrawGame) {
                  cubit.closeAd();
                  alertDialog(
                      title: 'Alert',
                      context: context,
                      meesage: "No One Win The Game");
                }
                if (state is WinGame) {
                  cubit.closeAd();
                  alertDialog(
                      title: 'Alert',
                      context: context,
                      meesage: cubit.playWithFriends
                          ? "player:  ${cubit.player} Win The Game"
                          : cubit.player == cubit.yourTurn
                              ? "You Win The Game"
                              : "You Lost - Win Bot : ${cubit.player} ");

                  cubit.calcScore();
                }
              },
              builder: (BuildContext context, GameStates state) {
                return WillPopScope(
                  onWillPop: () async {
                    cubit.closeAd();
                    return true;
                  },
                  child: Center(
                    child: BuildCondition(
                      condition: !cubit.loading,
                      fallback: (context) => const Center(
                          child: CircularProgressIndicator(
                        color: Color.fromRGBO(206, 222, 235, .5),
                      )),
                      builder: (_) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  cubit.playWithFriends
                                      ? "Current Player ${cubit.player}"
                                      : cubit.player == cubit.yourTurn
                                          ? "Your Turn "
                                          : "Current Bot ${cubit.player}",
                                  style: TBIBFontStyle.b1,
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
                                                padding:
                                                    const EdgeInsets.all(0),
                                                textStyle: TBIBFontStyle.b1),
                                            onPressed: cubit.playWithFriends
                                                ? cubit.number1() == i + 1
                                                    ? null
                                                    : () {
                                                        cubit.selectNum(i + 1);
                                                      }
                                                : cubit.player == cubit.yourTurn
                                                    ? cubit.number1() == i + 1
                                                        ? null
                                                        : () {
                                                            cubit.selectNum(
                                                                i + 1);
                                                          }
                                                    : null,
                                            child: Text(cubit.board[i]),
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
                                height:
                                    MyBannerAd.myBanner.size.height.toDouble(),
                                child: MyBannerAd.adWidget,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
