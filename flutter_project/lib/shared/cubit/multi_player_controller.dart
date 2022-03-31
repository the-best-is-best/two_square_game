import 'dart:convert';
import 'dart:developer';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:two_square_game/shared/cubit/multi_player/join_room_controller.dart';
import 'package:two_square_game/shared/network/dio_network.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wakelock/wakelock.dart';

import '../../screens/menu.dart';
import 'states/muli_player_states.dart';

class MultiPlayercubit extends Cubit<MultiPlyerStates> with JoinRoomcubit {
  bool adLoaded = false;

  MultiPlayercubit() : super(MultiPlyerInitialState());
  static MultiPlayercubit get(BuildContext context) => BlocProvider.of(context);
  static BuildContext? context;

  late List<dynamic> board;
  int numberOfPlayer = 2;
  late int _player;
  int? playerLost;
  int player() => _player;

  int _turn = 1;
  int turn() => _turn;

  int? _idRoom;
  int? idRoom() => _idRoom;

  int? playerWin;

  int? _number1, _number2;
  int? number1() => _number1;
  int countdownTimerTurn = 30;
  bool _gameStarted = false;
  bool gameStareted() => _gameStarted;

  bool roomError = false;
  void makeOrJoinRoom(int boardSize, int numOfPlayer) async {
    adLoaded = true;
    numberOfPlayer = numOfPlayer;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Response? response;
    try {
      emit(WaitingPlayer());
      response =
          await DioHelper.postData(url: "controller/control_room.php", query: {
        "gameVersion": packageInfo.buildNumber,
        "boardSize": boardSize,
        "numOfPlayer": numOfPlayer,
        "tokenPlayer": await FirebaseMessaging.instance.getToken(),
      });
    } catch (ex) {
      BotToast.showText(text: "Server Error");
      Navigator.pushAndRemoveUntil(
        context!,
        MaterialPageRoute(
          builder: (BuildContext context) => const Menu(),
        ),
        (route) => false,
      );
      log("error: $ex - " + packageInfo.buildNumber.toString());
    }
    if (response != null) {
      var data = response.data;
      String message = data['messages'][0];
      Map<String, String>? serverData;
      if (message.contains("Please Update Game First")) {
        emit(UpdateGameAlert());
        Navigator.pushAndRemoveUntil(
          context!,
          MaterialPageRoute(
            builder: (BuildContext context) => const Menu(),
          ),
          (route) => false,
        );
        return;
      }
      serverData = super.joinRoom(data['data']);

      if (serverData != null) {
        board = jsonDecode(serverData['board']!);
        _player = int.parse(serverData['player']!);
        _idRoom = int.parse(serverData['id']!);
        _turn = 1;

        try {
          log("joining room_$_idRoom");
        } catch (_) {
          log("Player " + _player.toString() + " failed to subscribe");
          Map<String, String> data = {
            "roomId": "$_idRoom",
            "userId": _player.toString()
          };

          await DioHelper.postData(
              url: "delete/user_logout_before_room_start.php", query: data);
          emit(FirebaseError());
          return;
        }

        if (message != "Join Room") {
          log("player" + _player.toString());
          return;
        }
      } else {
        emit(ServerError());
      }
    } else {
      emit(ServerError());
    }
    log("player" + _player.toString());
  }

  void playerJoined() async {
    countdownTimerTurn = 30;
    log("Start Game");
    emit(StartTime());
  }

  void selectNumbers(int num) {
    if (_number1 == null) {
      _number1 = num;
      emit(SelectedNumber());
      return;
    }
    if (num == _number1) {
      return;
    }
    BotToast.showLoading();
    _number2 ??= num;
    _played(_number1!, _number2!);

    _number1 = _number2 = null;
  }

  void _played(int num1, int num2) async {
    Map<String, String> data = {
      "roomId": "$_idRoom",
      "playerId": "$_player",
      "number1": "$num1",
      "number2": "$num2"
    };
    try {
      var response = await DioHelper.postData(
          url: "controller/control_room.php", query: data);
      String message = response.data['messages'][0];

      if (message == "You can't play here") {
        emit(YouCannotPlayHere());
        BotToast.closeAllLoading();
        return;
      } else if (message == "No One Win The Game") {
        emit(StopTime());
        _getBoardLocal(num1, num2);

        emit(DrawGame());
      } else if (message == "Next Player") {
        _getBoardLocal(num1, num2);
        int nextTurn = _player;
        if (nextTurn == numberOfPlayer) {
          nextTurn = 1;
        } else {
          nextTurn++;
        }

        emit(StopTime());
      } else if (message == "Player Win") {
        emit(StopTime());

        endGame(_player);
        emit(EndGame());
        log("Player Win");
      } else {
        roomError = true;
        emit(RoomError());
        log("room not applied");

        logout();
      }
    } catch (ex) {
      roomError = true;
      emit(RoomError());
      log("room not applied 1 ${ex.toString()}");

      logout();
    }
    BotToast.closeAllLoading();
  }

  void startTime(CountdownController time) async {
    log("player : " + _player.toString());
    if (!_gameStarted) {
      countdownTimerTurn = 30;
      _gameStarted = true;
      await time.start();
    } else {
      await time.restart();

      emit(GameReady());
      log("Time start");
    }
  }

  void stopTime(CountdownController time) async {
    await time.pause();

    emit(GameReady());
    log("Time stop");
  }

  void firebaseStartTime() {
    emit(StartTime());
  }

  void _getBoardLocal(int num1, int num2) {
    board[num1 - 1] = "x";
    board[num2 - 1] = "x";
  }

  void getBoard(int playerTurn) async {
    countdownTimerTurn = 15;
    emit(StartTime());
    try {
      if (playerTurn == _player) {
        BotToast.showLoading();
        Map<String, String> data = {
          "roomId": "$_idRoom",
          "message": "Get Data"
        };

        var response = await DioHelper.postData(
            url: "controller/control_room.php", query: data);

        board = jsonDecode(response.data['data']['board']);

        BotToast.closeAllLoading();

        emit(GameReady());
      } else {
        emit(GameReady());
        log("Not my Turn");
      }
    } catch (ex) {
      getBoard(playerTurn);
    }
    if (_turn == numberOfPlayer) {
      _turn = 1;
    } else {
      _turn++;
    }
  }

  void timeOut() {
    if (_turn == _player) logout();
  }

  void logout() async {
    await Wakelock.disable();
    _closeAd();

    if (_idRoom != null) {
      if (!_gameStarted) {
        Map<String, String> data = {
          "roomId": "$_idRoom",
          "userId": _player.toString()
        };

        await DioHelper.postData(
            url: "delete/user_logout_before_room_start.php", query: data);
        await FirebaseMessaging.instance.unsubscribeFromTopic("room_$_idRoom");
        try {
          Navigator.pushAndRemoveUntil(
            context!,
            MaterialPageRoute(
              builder: (BuildContext context) => const Menu(),
            ),
            (route) => false,
          );
        } catch (_) {}
      } else {
        if (_gameStarted && !roomError) {
          DioHelper.postData(url: "delete/room_delete.php", query: {
            "roomId": _idRoom,
            "playerToken": await FirebaseMessaging.instance.getToken(),
            "playerId": _player,
            "roomError": 0
          });
        } else if (_gameStarted && roomError) {
          await DioHelper.postData(url: "delete/room_delete.php", query: {
            "roomId": _idRoom,
            "playerToken": await FirebaseMessaging.instance.getToken(),
            "roomError": 1
          });
        }
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context!,
        MaterialPageRoute(
          builder: (BuildContext context) => const Menu(),
        ),
        (route) => false,
      );
    }
  }

  void _closeAd() {
    adLoaded = false;
  }

  void endGame(int? player) async {
    playerWin = player;
    emit(EndGame());
    // FirebaseMessaging.instance.unsubscribeFromTopic("room_$_idRoom");
  }

  void lostPlayer(int player) async {
    playerLost = player;
    emit(EndGame());
    // await FirebaseMessaging.instance.unsubscribeFromTopic("room_$_idRoom");
  }

  void roomIssue() async {
    playerWin = null;
    emit(EndGame());

    // await FirebaseMessaging.instance.unsubscribeFromTopic("room_$_idRoom");
  }
}
