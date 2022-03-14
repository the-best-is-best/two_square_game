import 'package:buildcondition/buildcondition.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tbib_style/tbib_style.dart';
import 'package:two_square_game/screens/game.dart';
import 'package:two_square_game/screens/multiplayer.dart';
import 'package:two_square_game/shared/controller/menu_controller.dart';
import 'package:two_square_game/shared/states/menu_states.dart';

import '../shared/ads/my_banner_ad.dart';
import '../shared/components.dart/app_bar.dart';
import '../shared/components.dart/push_page.dart';
import '../shared/ads/interstitial_ad.dart';
import '../shared/util/device_screen.dart';

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
        () => MyInterstitial.getInterstitialAd()?.show()));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: myAppBar('Choose 2 Squares - menu', context: context),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap back again to leave'),
        ),
        child: Builder(builder: (context) {
          MenuController cubit = MenuController.get(context);

          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: SizedBox(
              width: size.width,
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      "assets/img/game-icon.png",
                      height: 150,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text("Choose 2 Squares", style: TBIBFontStyle.h4),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 250.w,
                          height: 55.h,
                          child: BlocConsumer<MenuController, MenuStates>(
                            listener:
                                (BuildContext context, MenuStates state) {},
                            builder: (BuildContext context, MenuStates state) =>
                                DropdownButton<String>(
                              value: cubit.displayMode,
                              style: TBIBFontStyle.h1,
                              iconSize: 45.h,
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
                              onChanged: (String? val) =>
                                  cubit.changeMode(val!),
                              items: DeviceType.isSmallScreen()
                                  ? <String>[
                                      'Easy',
                                      'Medium',
                                    ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TBIBFontStyle.b1,
                                        ),
                                      );
                                    }).toList()
                                  : <String>['Easy', 'Medium', 'Hard']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
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
                        ),
                        const Padding(padding: EdgeInsets.only(top: 20)),
                        SizedBox(
                          height: 50.h,
                          width: 250.w,
                          child: ElevatedButton(
                            onPressed: () async {
                              MyInterstitial.getAd();
                              MyBannerAd.checkAdLoaded();
                              push(
                                context: context,
                                widget: Game(cubit.boardSize),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Play",
                                style: TBIBFontStyle.h3,
                              ),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 20)),
                        BuildCondition(
                          condition: DeviceType.isSmallScreen(),
                          builder: (_) => const SizedBox(),
                          fallback: (_) => SizedBox(
                            height: 50.h,
                            width: 250.w,
                            child: ElevatedButton(
                              onPressed: () async {
                                MyBannerAd.checkAdLoaded();
                                pushReplacementAll(
                                  context: context,
                                  widget: MultiPlayer(cubit.boardSize),
                                );
                              },
                              child: Text(
                                "Multiplayer",
                                style: TBIBFontStyle.h4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        DeviceType.isSmallScreen()
                            ? const Padding(padding: EdgeInsets.only(top: 30))
                            : const Padding(padding: EdgeInsets.only(top: 50)),
                        Text(
                          "Special Thanks :",
                          style: TBIBFontStyle.h3,
                        ),
                        const Padding(padding: EdgeInsets.only(top: 12)),
                        Text(
                          "Michelle Raouf",
                          style: DeviceType.isLargeScreen()
                              ? TBIBFontStyle.h4
                              : TBIBFontStyle.h5,
                        ),
                        //    const Padding(padding: EdgeInsets.only(top: 12)),
                        Text(
                          "John Raouf",
                          style: DeviceType.isLargeScreen()
                              ? TBIBFontStyle.h4
                              : TBIBFontStyle.h5,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
