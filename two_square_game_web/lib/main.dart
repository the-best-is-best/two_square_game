import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbib_style/tbib_style.dart';
import 'package:two_square_game/screens/splash_screen.dart';
import 'package:two_square_game/shared/cubit/menu_controller.dart';

import 'shared/bloc_observer.dart';
import 'shared/services/font_services.dart';
import 'shared/util/device_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  DeviceType();
  fontsServices();

  BlocOverrides.runZoned(
    () {
      runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final botToastBuilder = BotToastInit();
  bool isOpened = false;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(480, 960),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: () {
        return SizedBox(
          child: MultiBlocProvider(
              providers: [
                BlocProvider<Menucubit>(
                    create: (BuildContext context) => Menucubit()),
              ],
              child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Choose Two Squares',
                  builder: (context, child) {
                    if (!isOpened) {
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
                      isOpened = true;
                    }
                    child = child; //do something
                    child = botToastBuilder(context, child);
                    return child;
                  },
                  navigatorObservers: [BotToastNavigatorObserver()],
                  theme: ThemeData(
                    //scaffoldBackgroundColor: HexColor("8c3839"),
                    scaffoldBackgroundColor:
                        const Color.fromRGBO(127, 40, 45, 1),
                    //primaryColor: HexColor("cedeeb"),

                    elevatedButtonTheme: ElevatedButtonThemeData(
                        style: ElevatedButton.styleFrom(
                      //primary: const Color.fromRGBO(206, 222, 235, .5)
                      primary: const Color.fromRGBO(182, 82, 81, 1),
                    )),
                  ),
                  home: const SplashScreen())),
        );
      },
    );
  }
}
