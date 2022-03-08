import 'dart:developer';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tbib_style/tbib_style.dart';
import 'package:two_square_game/screens/game.dart';
import 'package:two_square_game/screens/multiplayer.dart';

import '../shared/components.dart/app_bar.dart';
import '../shared/components.dart/push_page.dart';
import '../shared/models/interstitial_ad.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  void initState() {
    super.initState();
    MyInterstitial.init();
    WidgetsBinding.instance!.addPostFrameCallback((_) => Future.delayed(
        const Duration(milliseconds: 500),
        () => MyInterstitial.getInterstitialAd().show()));
  }

  int boardSize = 4;
  String displayMode = "Easy";
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: myAppBar('2 square game - menu'),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap back again to leave'),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SizedBox(
            width: size.width,
            child: Column(
              children: [
                Image.asset(
                  "assets/img/game icon.png",
                  height: 150,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text("2 SQUARE GAME", style: TBIBFontStyle.h4),
                ),
                SizedBox(
                  height: size.height / 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 55,
                        child: DropdownButton<String>(
                          value: displayMode,
                          style: TBIBFontStyle.h4,
                          iconSize: 45,
                          icon: const Icon(Icons.arrow_drop_down),
                          isExpanded: true,
                          elevation: 16,
                          dropdownColor: HexColor("8c3839"),
                          iconEnabledColor:
                              const Color.fromRGBO(206, 222, 235, .5),
                          underline: Container(
                            height: 4,
                            color: const Color.fromRGBO(206, 222, 235, .5),
                          ),
                          onChanged: (String? val) {
                            switch (val) {
                              case 'Easy':
                                setState(() {
                                  boardSize = 4;
                                  displayMode = "Easy";
                                });
                                break;

                              case 'Medium':
                                setState(() {
                                  displayMode = "Medium";
                                  boardSize = 5;
                                });

                                break;

                              case 'Hard':
                                setState(() {
                                  displayMode = "Hard";
                                  boardSize = 6;
                                });

                                break;
                              default:
                                boardSize = 4;
                            }
                          },
                          items: <String>['Easy', 'Medium', 'Hard']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TBIBFontStyle.b1,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      ElevatedButton(
                        onPressed: () async {
                          MyInterstitial.getAd();
                          push(
                            context: context,
                            widget: Game(boardSize),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Text(
                              "Play",
                              style: TBIBFontStyle.h3,
                            ),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      ElevatedButton(
                        onPressed: () async {
                          pushReplacementAll(
                            context: context,
                            widget: MultiPlayer(boardSize),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Multiplayer",
                            style: TBIBFontStyle.h4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 75)),
                    Text(
                      "Special Thanks :",
                      style: TBIBFontStyle.h3,
                    ),
                    const Padding(padding: EdgeInsets.only(top: 12)),
                    Text(
                      "Michelle Raouf",
                      style: TBIBFontStyle.h5,
                    ),
                    const Padding(padding: EdgeInsets.only(top: 12)),
                    Text(
                      "John Raouf",
                      style: TBIBFontStyle.h5,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
