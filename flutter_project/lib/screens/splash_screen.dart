import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';
import 'package:play_game_service/play_game_service.dart';
import 'package:tbib_splash_screen/splash_screen.dart';

import 'menu.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    GamesServices.signIn();
    PlayGameService.signIn();
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreenView(
      navigateRoute: Menu(),
      duration: Duration(milliseconds: 610),
      imageSrc: "assets/lottie/logo.json",
      logoSize: 360,
    );
  }
}
