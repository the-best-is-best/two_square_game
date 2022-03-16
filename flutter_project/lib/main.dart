import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbib_style/tbib_style.dart';
import 'package:two_square_game/screens/splash_screen.dart';
import 'package:two_square_game/shared/cubit/menu_controller.dart';
import 'package:two_square_game/shared/cubit/multi_player_controller.dart';
import 'package:two_square_game/shared/network/dio_network.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'shared/bloc_observer.dart';
import 'shared/util/device_screen.dart';

const _kShouldTestAsyncErrorOnInit = false;

// Toggle this for testing Crashlytics in your app locally.
const _kTestingCrashlytics = true;

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _firebase();
    MobileAds.instance.initialize();

    DeviceType();
    _fonts();
    DioHelper();

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    BlocOverrides.runZoned(
      () {
        runApp(const MyApp());
      },
      blocObserver: MyBlocObserver(),
    );
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

Future<void> _firebase() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await FirebaseMessaging.instance.deleteToken();

  await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    Map? mapMessage;
    mapMessage = json.decode(message.data['listen']);

    if (mapMessage != null && mapMessage['message'] != null) {
      MultiPlayercubit cubit = MultiPlayercubit.get(MultiPlayercubit.context);

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
      } else if (mapMessage['message'] == "Room issue") {
        cubit.endGame(0);
      }
    }
  });
}

void _fonts() {
  if (DeviceType.isLargeScreen()) {
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
  log(TBIBFontStyle.h4.fontSize.toString());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final botToastBuilder = BotToastInit();
  late Future<void> _initializeFlutterFireFuture;

  Future<void> _testAsyncErrorOnInit() async {
    Future<void>.delayed(const Duration(seconds: 2), () {
      final List<int> list = <int>[];
      debugPrint(list[100].toString());
    });
  }

  // Define an async function to initialize FlutterFire
  Future<void> _initializeFlutterFire() async {
    // Wait for Firebase to initialize

    if (_kTestingCrashlytics) {
      // Force enable crashlytics collection enabled if we're testing it.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      // Else only enable it in non-debug builds.
      // You could additionally extend this to allow users to opt-in.
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);
    }

    if (_kShouldTestAsyncErrorOnInit) {
      await _testAsyncErrorOnInit();
    }
  }

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  @override
  void initState() {
    super.initState();
    _initializeFlutterFireFuture = _initializeFlutterFire();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(480, 960),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: () {
        return MultiBlocProvider(
          providers: [
            BlocProvider<Menucubit>(
                create: (BuildContext context) => Menucubit()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Choose Two Squares',
            builder: (context, child) {
              ScreenUtil.setContext(context);

              TBIBFontStyle.h3 = TBIBFontStyle.h3
                  .copyWith(fontSize: TBIBFontStyle.h3.fontSize!.sp);
              TBIBFontStyle.h4 = TBIBFontStyle.h4
                  .copyWith(fontSize: TBIBFontStyle.h4.fontSize!.sp);

              TBIBFontStyle.h5 = TBIBFontStyle.h5
                  .copyWith(fontSize: TBIBFontStyle.h5.fontSize!.sp);

              TBIBFontStyle.h6 = TBIBFontStyle.h6
                  .copyWith(fontSize: TBIBFontStyle.h6.fontSize!.sp);
              TBIBFontStyle.b1 = TBIBFontStyle.b1
                  .copyWith(fontSize: TBIBFontStyle.b1.fontSize!.sp);
              BotToastInit();
              child = child; //do something
              child = botToastBuilder(context, child);
              return child;
            },
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
            home: FutureBuilder(
              future: _initializeFlutterFireFuture,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      return const SplashScreen();
                    }
                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        );
      },
    );
  }
}
