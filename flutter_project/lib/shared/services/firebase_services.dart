import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_api_availability/google_api_availability.dart';

import '../cubit/multi_player_controller.dart';

class FirebaseInit {
  static String? token;

  static Future<String> firebaseServices(
      GooglePlayServicesAvailability playStoreAvailability,
      bool isInternet) async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (playStoreAvailability == GooglePlayServicesAvailability.success &&
          isInternet) {
        await Firebase.initializeApp();

        await FirebaseMessaging.instance.deleteToken();

        token = await FirebaseMessaging.instance.getToken();

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          Map? mapMessage;
          mapMessage = json.decode(message.data['listen']);
          log("firebase message listen");
          if (mapMessage != null && mapMessage['message'] != null) {
            if (MultiPlayercubit.context != null) {
              MultiPlayercubit cubit =
                  MultiPlayercubit.get(MultiPlayercubit.context!);

              if (mapMessage['message'] == "joined") {
                cubit.playerJoined();
              } else if (mapMessage['message']
                  .toString()
                  .contains("player win")) {
                int playerWin = int.parse(mapMessage['message']
                    [mapMessage['message'].toString().length - 1]);
                cubit.endGame(playerWin);
              } else if (mapMessage['message']
                  .toString()
                  .contains("player lost")) {
                int playerLost = int.parse(mapMessage['message']
                    [mapMessage['message'].toString().length - 1]);
                cubit.lostPlayer(playerLost);
              } else if (mapMessage['message'] == "No One Win The Game") {
                cubit.endGame(0);
              } else if (mapMessage['message']
                  .toString()
                  .contains("Get Data Player")) {
                log("get Board");
                int player = int.parse(mapMessage['message']
                    [mapMessage['message'].toString().length - 1]);
                cubit.getBoard(player);
              } else if (mapMessage['message']
                  .toString()
                  .contains("Player Win")) {
                List messageData = mapMessage['message'].toString().split('-');
                int playerId = int.parse(messageData[1]);
                cubit.endGame(playerId);
              } else if (mapMessage['message'].toString() == "Start Time") {
                cubit.countdownTimerTurn = 30;
                cubit.firebaseStartTime();
              } else if (mapMessage['message'] == "Room issue") {
                cubit.roomIssue();
              } else {
                log("i got nothing, message : " +
                    mapMessage['message'].toString());
              }
            } else {
              log("Page null");
              MultiPlayercubit cubit =
                  MultiPlayercubit.get(MultiPlayercubit.context!);
              cubit.logout();
            }
          } else {
            log("Message null ");
          }
        });
        return "success";
      }
    } catch (_) {
      return "error";
    }
    return "error";
  }
}
