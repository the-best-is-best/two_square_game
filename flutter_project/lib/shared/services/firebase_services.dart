import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_api_availability/google_api_availability.dart';

import '../cubit/multi_player_controller.dart';

Future<void> firebaseServices(
    GooglePlayServicesAvailability playStoreAvailability,
    bool isInternet) async {
  WidgetsFlutterBinding.ensureInitialized();

  // If the widget was removed from the tree while the asynchronous platform
  // message was in flight, we want to discard the reply rather than calling
  // setState to update our non-existent appearance.
  if (playStoreAvailability == GooglePlayServicesAvailability.success &&
      isInternet) {
    await Firebase.initializeApp();

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    await FirebaseMessaging.instance.deleteToken();

    await FirebaseMessaging.instance.getToken();
  }
}
