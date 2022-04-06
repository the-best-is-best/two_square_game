import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:play_game_service/play_game_service.dart';
import 'package:tbib_style/responsive_font.dart';
import 'package:two_square_game/screens/splash_screen.dart';
import 'package:two_square_game/shared/cubit/menu_controller.dart';
import 'package:two_square_game/shared/network/dio_network.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:two_square_game/shared/services/check_internet.dart';
import 'package:two_square_game/shared/services/firebase_services.dart';
import 'package:two_square_game/shared/services/google_play/save_data.dart';

import 'shared/bloc_observer.dart';
import 'shared/services/alert_google_services.dart';
import 'shared/services/font_services.dart';
import 'shared/util/device_screen.dart';

const _kShouldTestAsyncErrorOnInit = false;

// Toggle this for testing Crashlytics in your app locally.
const _kTestingCrashlytics = true;

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    PlayGameService.signIn(scopeSnapShot: true)
        .then((_) => loadDataGooglePlay());

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    await CheckInternet.init();
    await GoogleServesesChecker.init();
    await FirebaseInit.firebaseServices(
        GoogleServesesChecker.getPlaSytoreAvailability,
        CheckInternet.isConnected);

    MobileAds.instance.initialize();

    DeviceType();
    fontsServices();
    DioHelper();

    if (GoogleServesesChecker.getPlaSytoreAvailability ==
            GooglePlayServicesAvailability.success &&
        CheckInternet.isConnected) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }
    BlocOverrides.runZoned(
      () {
        runApp(const MyApp());
      },
      blocObserver: MyBlocObserver(),
    );
  }, (error, stackTrace) {
    if (GoogleServesesChecker.getPlaSytoreAvailability ==
            GooglePlayServicesAvailability.success &&
        CheckInternet.isConnected) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  final botToastBuilder = BotToastInit();

  Future<void>? _initializeFlutterFireFuture;

  @override
  void initState() {
    super.initState();
    if (GoogleServesesChecker.getPlaSytoreAvailability ==
            GooglePlayServicesAvailability.success &&
        CheckInternet.isConnected) {
      _initializeFlutterFireFuture = _initializeFlutterFire();
    }
  }

  Future<void> firebaseError() async {}

  Future<void> _testAsyncErrorOnInit() async {
    Future<void>.delayed(const Duration(seconds: 2), () {
      final List<int> list = <int>[];
      debugPrint(list[100].toString());
    });
  }

  // Define an async function to initialize FlutterFire
  Future<void> _initializeFlutterFire() async {
    // Wait for Firebase to initialize
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

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

              ResponiveFont.responsive();
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
              future: _initializeFlutterFireFuture ?? firebaseError(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      GoogleServesesChecker.alertGoogleServices();
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
