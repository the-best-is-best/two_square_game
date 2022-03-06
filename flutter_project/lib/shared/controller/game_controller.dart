import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_square_game/shared/states/game_states.dart';

class GameController extends Cubit<GameStates> {
  GameController() : super(GameInitialState());
  static GameController get(context) => BlocProvider.of(context);

  List<String> board = [];
  int player = 1;

  int? _number1, _number2;

  int? number1() => _number1;

  int boardSize = 0;
  bool loading = false;
  int totalGameNum = 0;

  void gameMode(int addBoardSize) {
    boardSize = addBoardSize;
    emit(GamePlayed());
  }

  void startGame() async {
    loading = true;
    totalGameNum = pow(boardSize, 2).toInt();

    for (int i = 0; i < totalGameNum; i++) {
      board.add("${i + 1}");
    }
    await Future.delayed(const Duration(milliseconds: 500));
    loading = false;
    emit(GamePlayed());
  }

  void selectNum(int num) {
    if (_number1 == null) {
      _number1 = num;
      emit(SelectedNumber());
      return;
    }
    if (num == _number1) {
      return;
    }
    _number2 ??= num;

    _action(_number1, _number2);
    _number1 = _number2 = null;
  }

  void _action(action1, action2) {
    BotToast.showLoading();
    if (board[action1 - 1] != "x" && board[action2 - 1] != "x") {
      if ((action2 - action1).abs() == boardSize ||
          (action2 - action1).abs() == 1) {
        if (action1 != totalGameNum || action2 != totalGameNum) {
          if (action1 % boardSize == 0 && action2 == action1 + 1 ||
              action2 % boardSize == 0 && action1 == action2 + 1) {
            emit(CannotPlayHere());
            BotToast.closeAllLoading();
            return;
          }
        }

        board[action1 - 1] = "x";
        board[action2 - 1] = "x";

        int turns = 0;
        bool draw = true;

        for (int i = 0; i < board.length; i++) {
          if (board[i] != "x") {
            draw = false;

            if ((i + 1) % boardSize != 0) {
              if ((i + 1) < totalGameNum && board[i + 1] != "x") {
                turns += 1;

                break;
              }
            }

            if ((i) % (boardSize) != 0) {
              if ((i - 1) >= 0 && board[i - 1] != "x") {
                turns += 1;

                break;
              }
            }

            if ((i - boardSize) >= 0 && board[i - boardSize] != "x") {
              turns += 1;

              break;
            }

            if ((i + boardSize) < totalGameNum && board[i + boardSize] != "x") {
              turns += 1;

              break;
            }
          }
        }
        if (draw == true) {
          emit(DrawGame());
          BotToast.closeAllLoading();
          return;
        }

        if (turns != 0) {
          emit(GamePlayed());
          if (player == 1) {
            player = 2;
          } else {
            player = 1;
          }
        } else {
          emit(WinGame());
        }
      } else {
        emit(CannotPlayHere());
      }
    } else {
      emit(CannotPlayHere());
    }
    BotToast.closeAllLoading();
  }
}
