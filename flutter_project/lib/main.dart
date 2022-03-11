import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbib_style/tbib_style.dart';
import 'package:two_square_game/shared/ads/my_banner_ad.dart';
import 'package:two_square_game/shared/network/dio_network.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'screens/splash_screen.dart';
import 'shared/bloc_observer.dart';
import 'shared/controller/multi_player_controller.dart';
import 'shared/const/device_is_tablet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  _firebase();
  _fonts();
  DioHelper();

  //MyBannerAd.loadWidget();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  BlocOverrides.runZoned(
    () {
      runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

void _firebase() async {
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.deleteToken();

  await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    Map? mapMessage;
    mapMessage = json.decode(message.data['listen']);

    if (mapMessage != null && mapMessage['message'] != null) {
      MultiPlayerController cubit =
          MultiPlayerController.get(MultiPlayerController.context);

      if (mapMessage['message'] == "joined") {
        cubit.countdownTimerTurn =
            DateTime.now().millisecondsSinceEpoch + 1000 * 30;
        cubit.playerJoined();
      } else if (mapMessage['message'] == "player win 1") {
        cubit.endGame(1);
      } else if (mapMessage['message'] == "player win 2") {
        cubit.endGame(2);
      } else if (mapMessage['message'] == "No One Win The Game") {
        cubit.endGame(0);
      } else if (mapMessage['message'].toString().contains("Get Data Player")) {
        List messageData = mapMessage['message'].toString().split('-');
        cubit.countdownTimerTurn =
            DateTime.now().millisecondsSinceEpoch + 1000 * 30;
        int playerId = int.parse(messageData[1]);
        cubit.getBoard(playerId);
      } else if (mapMessage['message'].toString().contains("Player Win")) {
        List messageData = mapMessage['message'].toString().split('-');
        int playerId = int.parse(messageData[1]);
        cubit.endGame(playerId);
      } else if (mapMessage['message'].toString() == "Start Time") {
        cubit.firebaseStartTime();
      }
    }
  });
}

void _fonts() {
  if (DeviceIsTablet.isTablet()) {
    TBIBFontStyle.defaultFlutterStyle();
    TBIBFontStyle.h4 = TBIBFontStyle.h4.copyWith(fontWeight: FontWeight.w400);
    TBIBFontStyle.h3 = TBIBFontStyle.h3.copyWith(fontWeight: FontWeight.w600);
  }
  TBIBFontStyle.lisenGoogleFont(GoogleFonts.spaceMono());
  TBIBFontStyle.h4 = TBIBFontStyle.h4.copyWith(
    color: const Color.fromRGBO(206, 222, 235, .5),
  );
  TBIBFontStyle.h3 = TBIBFontStyle.h3.copyWith(
    color: const Color.fromRGBO(206, 222, 235, .5),
  );
  TBIBFontStyle.b1 = TBIBFontStyle.b1.copyWith(
    color: const Color.fromRGBO(206, 222, 235, .5),
  );

  TBIBFontStyle.h5 = TBIBFontStyle.h5.copyWith(
    color: const Color.fromRGBO(206, 222, 235, .5),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '2 Square Game',
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(
        //scaffoldBackgroundColor: HexColor("8c3839"),
        scaffoldBackgroundColor: const Color.fromRGBO(127, 40, 45, 1),
        //primaryColor: HexColor("cedeeb"),

        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          //primary: const Color.fromRGBO(206, 222, 235, .5)
          primary: const Color.fromRGBO(182, 82, 81, 1),
        )),
      ),
      home: const SplashScreen(),
    );
  }
}
