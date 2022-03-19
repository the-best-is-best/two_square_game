import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        } else if (mapMessage['message']
            .toString()
            .contains("Get Data Player")) {
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
}
