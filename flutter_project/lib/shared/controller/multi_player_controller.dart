import 'dart:convert';
import 'dart:developer';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_square_game/shared/controller/multi_player/create_room_controller.dart';
import 'package:two_square_game/shared/controller/multi_player/join_room_controller.dart';
import 'package:two_square_game/shared/network/dio_network.dart';

import '../../screens/menu.dart';
import '../components.dart/push_page.dart';
import '../states/muli_player_states.dart';

class MultiPlayerController extends Cubit<MultiPlyerStates>
    with CreateRoomController, JoinRoomController {
  MultiPlayerController() : super(MultiPlyerInitialState());
  static MultiPlayerController get(BuildContext context) =>
      BlocProvider.of(context);
  static BuildContext? context;

  late List<dynamic> board;
  late int _player;
  int player() => _player;

  late int _turn;
  int turn() => _turn;

  late int _idRoom;
  int idRoom() => _idRoom;

  int? playerWin;

  int? _number1, _number2;
  int? number1() => _number1;
  void makeOrJoinRoom(int boardSize) async {
    emit(WaitingPlayer());
    var response =
        await DioHelper.postData(url: "controller/control_room.php", query: {
      "boardSize": boardSize,
    });
    var data = response.data;
    Map<String, String>? serverData;

    if (data['messages'][0] == "Room Created") {
      serverData = super.createRoom(data['data']);
    } else {
      serverData = super.joinRoom(data['data']);
    }
    if (serverData != null) {
      board = jsonDecode(serverData['board']!);
      _player = int.parse(serverData['player']!);
      _idRoom = int.parse(serverData['id']!);
      _turn = 1;

      await FirebaseMessaging.instance.subscribeToTopic("room_$_idRoom");
      await Future.delayed(const Duration(milliseconds: 500));

      if (data['messages'][0] == "Room Created") {
        return;
      }
      Map sendData = {"message": "joined"};

      await DioHelper.postNotification(to: "room_$_idRoom", data: sendData);
    } else {
      emit(ServerError());
    }
  }

  void playerJoined() {
    emit(GameReady());
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
    _number2 ??= num;
    _played(_number1!, _number2!);

    _number1 = _number2 = null;
  }

  void _played(int num1, int num2) async {
    BotToast.showLoading();
    Map<String, String> data = {
      "roomId": "$_idRoom",
      "playerId": "$_player",
      "number1": "$num1",
      "number2": "$num2"
    };

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

      await DioHelper.postNotification(to: "room_$_idRoom", data: sendData);
      emit(DrawGame());
    } else if (message == "Next Player") {
      _getBoardLocal(num1, num2);
      int nextTurn = _player == 1 ? 2 : 1;

      Map sendData = {"message": "Get Data Player-$nextTurn"};

      await DioHelper.postNotification(to: "room_$_idRoom", data: sendData);
      emit(GameReady());
    } else if (message == "Player Win") {
      Map sendData = {"message": "Player Win-$_player"};

      await DioHelper.postNotification(to: "room_$_idRoom", data: sendData);

      endGame(_player);
      emit(EndGame());
    } else {
      logout();
    }
    BotToast.closeAllLoading();
  }

  void _getBoardLocal(int num1, int num2) {
    board[num1 - 1] = "x";
    board[num2 - 1] = "x";
  }

  void getBoard(int playerTurn) async {
    if (playerTurn == _player) {
      BotToast.showLoading();
      Map<String, String> data = {"roomId": "$_idRoom", "message": "Get Data"};

      var response = await DioHelper.postData(
          url: "controller/control_room.php", query: data);
      _turn = _turn == 1 ? 2 : 1;
      board = jsonDecode(response.data['data']['board']);
      BotToast.closeAllLoading();
      emit(GameReady());
    } else {
      _turn = _turn == 1 ? 2 : 1;
      emit(GameReady());
    }
  }

  void logout() async {
    await FirebaseMessaging.instance.unsubscribeFromTopic("room_$_idRoom");
    Map sendData = {};
    if (_player == 1) {
      sendData = {"message": "player win 2"};
    } else {
      sendData = {"message": "player win 1"};
    }

    await DioHelper.postNotification(to: "room_$_idRoom", data: sendData);
    pushReplacementAll(
      context: context!,
      widget: const Menu(),
    );
  }

  void endGame(int? player) async {
    playerWin = player;
    emit(EndGame());
    await FirebaseMessaging.instance.unsubscribeFromTopic("room_$_idRoom");
  }
}