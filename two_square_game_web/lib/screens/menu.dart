import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tbib_style/tbib_style.dart';
import '../shared/components.dart/app_bar.dart';
import '../shared/components.dart/custom_dialog.dart';
import '../shared/components.dart/push_page.dart';
import '../shared/cubit/menu_controller.dart';
import '../shared/cubit/states/menu_states.dart';
import '../shared/util/device_screen.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'how_to_play.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('Choose 2 Squares - menu', context: context),
      body: Builder(
        builder: (context) {
          Menucubit cubit = Menucubit.get(context);

          return BlocConsumer<Menucubit, MenuStates>(
            listener: (BuildContext context, MenuStates state) {},
            builder: (BuildContext context, MenuStates state) => Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: SizedBox(
                  width: 480,
                  height: 960,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.asset(
                            "assets/img/game-icon.png",
                            height: 150,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child:
                              Text("Choose 2 Squares", style: TBIBFontStyle.h4),
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
                                child: DropdownButton<String>(
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
                                    color:
                                        const Color.fromRGBO(206, 222, 235, .5),
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
                              const Padding(padding: EdgeInsets.only(top: 20)),
                              SizedBox(
                                height: 50.h,
                                width: 250.w,
                                child: ElevatedButton(
                                  onPressed: cubit.multiClicked
                                      ? null
                                      : () async {
                                          askQuestions(
                                            context: context,
                                            cubitMenu: cubit,
                                          );
                                        },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Play",
                                      style: TBIBFontStyle.h4,
                                    ),
                                  ),
                                ),
                              ),
                              BuildCondition(
                                  condition: DeviceType.isSmallScreen(),
                                  builder: (_) => const SizedBox(),
                                  fallback: (_) => const Padding(
                                      padding: EdgeInsets.only(top: 20))),
                              BuildCondition(
                                condition: DeviceType.isSmallScreen(),
                                builder: (_) => const SizedBox(),
                                fallback: (_) => SizedBox(
                                  height: 50.h,
                                  width: 250.w,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      js.context.callMethod('open', [
                                        'https://play.google.com/store/apps/details?id=com.hardihood.two_square_game'
                                      ]);
                                    },
                                    child: Text(
                                      "Multiplayer",
                                      style: TBIBFontStyle.h4,
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 20)),
                              SizedBox(
                                height: 50.h,
                                width: 250.w,
                                child: ElevatedButton(
                                  onPressed: cubit.multiClicked
                                      ? null
                                      : () async {
                                          push(
                                            context: context,
                                            widget: const HowToPlay(),
                                          );
                                        },
                                  child: Text(
                                    "How To Play",
                                    style: TBIBFontStyle.h4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: DeviceType.isSmallScreen()
                                ? Alignment.topLeft
                                : Alignment.topCenter,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  DeviceType.isMediumScreen()
                                      ? const Padding(
                                          padding: EdgeInsets.only(top: 30))
                                      : const Padding(
                                          padding: EdgeInsets.only(top: 50)),
                                  Text(
                                    "Special Thanks :",
                                    style: TBIBFontStyle.h3,
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 12)),
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
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          "Privacy",
          style: TBIBFontStyle.h6,
        ),
        onPressed: () {
          js.context.callMethod('open',
              ['https://pages.flycricket.io/choose-2-squares/privacy.html']);
        },
        backgroundColor: const Color.fromRGBO(182, 82, 81, 1),
      ),
    );
  }
}
