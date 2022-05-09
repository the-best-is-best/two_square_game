import 'package:flutter/material.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:tbib_gms_google_play/tbib_gms_google_play.dart';
import 'package:tbib_splash_screen/splash_screen.dart';

import '../shared/services/alert_google_services.dart';
import '../shared/services/google_play/save_data.dart';
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
    try {
      if (GoogleServesesChecker.getPlaSytoreAvailability ==
          GooglePlayServicesAvailability.success) {
        TBIBGMSGooglePlay.signIn().then((value) {
          loadDataGooglePlay();
        });
      }
    } catch (_) {}
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
