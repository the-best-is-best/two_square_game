import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:two_square_game/shared/cubit/multi_player/create_room_controller.dart';
import 'package:two_square_game/shared/cubit/multi_player/join_room_controller.dart';
import 'package:two_square_game/shared/network/dio_network.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../screens/menu.dart';
import 'states/muli_player_states.dart';

class MultiPlayercubit extends Cubit<MultiPlyerStates>
    with CreateRoomcubit, JoinRoomcubit {
  bool adLoaded = false;

  MultiPlayercubit() : super(MultiPlyerInitialState());
  static MultiPlayercubit get(BuildContext context) => BlocProvider.of(context);
  static late BuildContext context;

  late List<dynamic> board;
  late int _player;
  int player() => _player;

  int? _turn;
  int? turn() => _turn;

  int? _idRoom;
  int? idRoom() => _idRoom;

  int? playerWin;

  int? _number1, _number2;
  int? number1() => _number1;
  int countdownTimerTurn = 30;
  bool _gameStarted = false;
  bool gameStareted() => _gameStarted;

  bool roomError = false;
  void makeOrJoinRoom(int boardSize) async {
    adLoaded = true;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    late Response response;
    try {
      emit(WaitingPlayer());
      response =
          await DioHelper.postData(url: "controller/control_room.php", query: {
        "gameVersion": packageInfo.buildNumber,
        "boardSize": boardSize,
      });
    } catch (ex) {
      BotToast.showText(text: "Server Error");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const Menu(),
        ),
        (route) => false,
      );
      log(packageInfo.buildNumber.toString());
    }
    var data = response.data;
    String message = data['messages'][0];
    Map<String, String>? serverData;
    if (message.contains("Please Update Game First")) {
      emit(UpdateGameAlert());
      return;
    } else if (message == "Room Created") {
      serverData = super.createRoom(data['data']);
    } else {
      serverData = super.joinRoom(data['data']);
    }
    if (serverData != null) {
      board = jsonDecode(serverData['board']!);
      _player = int.parse(serverData['player']!);
      _idRoom = int.parse(serverData['id']!);
      _turn = 1;

      try {
        await FirebaseMessaging.instance.subscribeToTopic("room_$_idRoom");
      } catch (_) {
        emit(FirebaseError());
        return;
      }
      await Future.delayed(const Duration(milliseconds: 500));

      if (message == "Room Created") {
        return;
      }
      Map sendData = {"message": "joined"};

      await DioHelper.postNotification(to: "room_$_idRoom", data: sendData);
    } else {
      emit(ServerError());
    }
  }

  void playerJoined() async {
    countdownTimerTurn = 5;
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
        _getBoardLocal(num1, num2);
        Map sendData = {"message": "No One Win The Game"};
        emit(StopTime());

        await DioHelper.postNotification(to: "room_$_idRoom", data: sendData);
        emit(DrawGame());
      } else if (message == "Next Player") {
        _getBoardLocal(num1, num2);
        int nextTurn = _player == 1 ? 2 : 1;
        countdownTimerTurn = 15;

        Map sendData = {"message": "Get Data Player-$nextTurn"};

        await DioHelper.postNotification(to: "room_$_idRoom", data: sendData);
        emit(StartTime());
      } else if (message == "Player Win") {
        Map sendData = {"message": "Player Win-$_player"};
        emit(StopTime());

        await DioHelper.postNotification(to: "room_$_idRoom", data: sendData);

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
      countdownTimerTurn = 30;
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
    emit(StopTime());
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
        //_turn = _turn == 1 ? 2 : 1;
        Map sendData = {"message": "Start Time"};
        await DioHelper.postNotification(to: "room_$_idRoom", data: sendData);
        BotToast.closeAllLoading();
        log("time started");
        emit(GameReady());
        log("Get Board");
      } else {
        //_turn = _turn == 1 ? 2 : 1;
        emit(GameReady());
        log("Not my Turn");
      }
    } catch (ex) {
      getBoard(playerTurn);
    }
    _turn = _turn == 1 ? 2 : 1;
  }

  void timeOut() {
    if (_turn == _player) logout();
  }

  void logout() async {
    _closeAd();
    if (_idRoom != null) {
      await DioHelper.postData(
          url: "delete/room_delete.php", query: {"roomId": _idRoom});
      if (!gameStareted()) {
        await FirebaseMessaging.instance.unsubscribeFromTopic("room_$_idRoom");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const Menu(),
          ),
          (route) => false,
        );
      } else {
        if (_gameStarted && !roomError) {
          Map sendData = {};
          if (_player == 1) {
            sendData = {"message": "player win 2"};
          } else {
            sendData = {"message": "player win 1"};
          }

          await DioHelper.postNotification(to: "room_$_idRoom", data: sendData);
          try {
            emit(LogoutGame());
          } catch (_) {}
        } else if (_gameStarted && roomError) {
          Map sendData = {};
          sendData = {"message": "Room issue"};

          await DioHelper.postNotification(to: "room_$_idRoom", data: sendData);
        }

        await FirebaseMessaging.instance.unsubscribeFromTopic("room_$_idRoom");
      }
    }
  }

  void _closeAd() {
    adLoaded = false;
  }

  void endGame(int? player) async {
    playerWin = player;
    emit(EndGame());
    await FirebaseMessaging.instance.unsubscribeFromTopic("room_$_idRoom");
  }

  void roomIssue() async {
    playerWin = null;
    emit(EndGame());

    await FirebaseMessaging.instance.unsubscribeFromTopic("room_$_idRoom");
  }
}
