import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_square_game/shared/services/google_play/save_data.dart';
import '../models/your_data.dart';
import '../services/google_play/control_google_play.dart';
import 'states/game_states.dart';

class Gamecubit extends Cubit<GameStates> {
  bool adLoaded = false;

  Gamecubit() : super(GameInitialState());
  static Gamecubit get(context) => BlocProvider.of(context);

  bool playWithFriends = false;

  List<String> board = [];
  int player = 1;
  late int yourTurn;

  int numberOfPlayer = 2;

  int? _number1, _number2;

  int? number1() => _number1;

  int boardSize = 0;
  bool loading = false;
  int totalGameNum = 0;

  late List<List<int>> availableGame;

  late double _yourScore;

  Stopwatch stopwatch = Stopwatch();
  void closeAd() {
    adLoaded = false;
    emit(ClosedAd());
  }

  void gameMode(int addBoardSize) {
    boardSize = addBoardSize;
  }

  void startGame(
      {required int numOfPlayer,
      required bool withFriend,
      required int sendBoard}) async {
    playWithFriends = withFriend;
    adLoaded = true;
    loading = true;
    boardSize = sendBoard;
    totalGameNum = pow(boardSize, 2).toInt();
    numberOfPlayer = numOfPlayer;
    for (int i = 0; i < totalGameNum; i++) {
      board.add("${i + 1}");
    }
    await Future.delayed(const Duration(milliseconds: 500));
    loading = false;
    if (!playWithFriends) {
      _yourScore = ((boardSize * numOfPlayer) / (boardSize + numOfPlayer)) *
          pow(10 * numOfPlayer / 2, numOfPlayer);

      if (boardSize == 4) {
        _yourScore *= 2;
      }
      Random ran = Random();
      yourTurn = ran.nextInt(numOfPlayer) + 1;

      if (yourTurn != 1) {
        _action(null, null);
      }

      stopwatch.start();
    }
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

  void _action(int? action1, int? action2) {
    if (action1 == null && action2 == null) {
      availableGame =
          List.generate(totalGameNum, (i) => List.generate(4, (i) => 0));
      for (int i = 0; i < board.length; i++) {
        if ((i + 1) % boardSize != 0) {
          if ((i + 1) < totalGameNum) {
            availableGame[i][0] = i + 2;
          }
        }

        if ((i) % (boardSize) != 0) {
          if ((i - 1) >= 0) {
            availableGame[i][1] = i;
          }
        }

        if ((i - boardSize) >= 0) {
          availableGame[i][2] = i + 1 - boardSize;
        }

        if ((i + boardSize) < totalGameNum) {
          availableGame[i][3] = i + 1 + boardSize;
        }
      }

      aiPlay();
      emit(GamePlayed());
    } else {
      if (board[action1! - 1] != "x" && board[action2! - 1] != "x") {
        if ((action2 - action1).abs() == boardSize ||
            (action2 - action1).abs() == 1) {
          if (action1 != totalGameNum || action2 != totalGameNum) {
            if (action1 % boardSize == 0 && action2 == action1 + 1 ||
                action2 % boardSize == 0 && action1 == action2 + 1) {
              emit(CannotPlayHere());

              return;
            }
          }
          stopwatch.stop();

          board[action1 - 1] = "x";
          board[action2 - 1] = "x";
          availableGame =
              List.generate(totalGameNum, (i) => List.generate(4, (i) => 0));
          bool turns = false;
          bool draw = true;

          for (int i = 0; i < board.length; i++) {
            if (board[i] != "x") {
              draw = false;

              if ((i + 1) % boardSize != 0) {
                if ((i + 1) < totalGameNum && board[i + 1] != "x") {
                  turns = true;
                  availableGame[i][0] = i + 2;
                }
              }

              if ((i) % (boardSize) != 0) {
                if ((i - 1) >= 0 && board[i - 1] != "x") {
                  turns = true;
                  availableGame[i][1] = i;
                }
              }

              if ((i - boardSize) >= 0 && board[i - boardSize] != "x") {
                turns = true;
                availableGame[i][2] = i + 1 - boardSize;
              }

              if ((i + boardSize) < totalGameNum &&
                  board[i + boardSize] != "x") {
                turns = true;
                availableGame[i][3] = i + 1 + boardSize;
              }
            }
          }
          if (draw == true) {
            emit(DrawGame());

            return;
          }

          if (turns) {
            if (player == numberOfPlayer) {
              player = 1;
            } else {
              player++;
            }
            if (!playWithFriends) {
              if (player != yourTurn) {
                aiPlay();
              }
              stopwatch.start();
              try {
                emit(GamePlayed());
              } catch (_) {}
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
    }
  }

  void aiPlay({bool first = true}) async {
    Random ran = Random();

    int wait = 0;
    if (first) {
      wait = ran.nextInt(1000) + 1000;
    }
    Future.delayed(Duration(milliseconds: wait)).then((_) {
      bool played = false;
      for (int x = 0; x < totalGameNum; x++) {
        int turns = 0;
        int numY = 0;
        for (int y = 0; y < 4; y++) {
          if (availableGame[x][y] != 0) {
            turns++;
            numY = availableGame[x][y];
          }
        }
        List<int> avalibleGameAccess = [];
        if (turns == 1) {
          int num2 = 0;

          for (int z = 0; z < 4; z++) {
            if (availableGame[numY - 1][z] != 0 &&
                availableGame[numY - 1][z] != x + 1) {
              num2 = availableGame[numY - 1][z];
              avalibleGameAccess.add(num2);
            }
          }
          if (avalibleGameAccess.length == 1) {
            _action(numY, num2);
            played = true;
            break;
          } else if (avalibleGameAccess.isNotEmpty) {
            int random = ran
                .nextInt(avalibleGameAccess.length * avalibleGameAccess.length);
            num2 = avalibleGameAccess[
                (random / avalibleGameAccess.length).floor()];

            _action(numY, num2);
            played = true;
            break;
          }
        }
      }
      if (!played) {
        int index = ran.nextInt(totalGameNum);
        int index2 = ran.nextInt(4);

        if (availableGame[index][index2] != 0) {
          _action(index + 1, availableGame[index][index2]);
        } else {
          aiPlay(first: false);
          return;
        }
      }
    });
  }

  void calcScore() {
    if (!playWithFriends && player == yourTurn) {
      stopwatch.stop();
      double mode = boardSize - 3;
      double timeLost = stopwatch.elapsedMilliseconds / (10000 * mode * 2 / 3);

      _yourScore = _yourScore / timeLost;

      if (mode != 1) {
        if (numberOfPlayer == 2) {
          _yourScore *= mode == 2 ? 3 : 5;
        }
        if (yourTurn == 1 || yourTurn == numberOfPlayer) {
          _yourScore *= 2;
        }
      }

      YourData.score += _yourScore.round();
      achivLeader(mode: mode, numberOfPlayer: numberOfPlayer);

      saveDataGooglePaly();
    }
  }

  void unlocArchiv() {
    if (!playWithFriends && player == yourTurn) {
      stopwatch.stop();
      double mode = boardSize - 3;
      double timeLost = stopwatch.elapsedMilliseconds / (10000 * mode * 2 / 3);

      _yourScore = _yourScore / timeLost;

      if (mode != 1) {
        if (numberOfPlayer == 2) {
          _yourScore *= mode == 2 ? 3 : 5;
        }
        if (yourTurn == 1 || yourTurn == numberOfPlayer) {
          _yourScore *= 2;
        }
      }

      YourData.score += _yourScore.round();
      achivLeader(mode: mode, numberOfPlayer: numberOfPlayer);

      saveDataGooglePaly();
    }
  }
}
