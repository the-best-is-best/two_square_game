import 'package:flutter/material.dart';
import 'package:tbib_splash_screen/splash_screen.dart';

import 'menu.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: const Menu(),
      duration: const Duration(milliseconds: 610),
      imageSrc: "assets/lottie/logo.json",
      logoSize: 360,
    );
  }
}
