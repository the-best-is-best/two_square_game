import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_square_game/shared/states/menu_states.dart';

class MenuController extends Cubit<MenuStates> {
  MenuController() : super(MenuInitialStates());
  static MenuController get(context) => BlocProvider.of(context);

  int boardSize = 4;
  String displayMode = "Easy";

  void changeMode(String mode) {
    if (mode == displayMode) {
      return;
    }
    if (mode == "Easy") {
      boardSize = 4;
      displayMode = "Easy";
    } else if (mode == "Medium") {
      boardSize = 5;
      displayMode = "Medium";
    } else {
      boardSize = 6;
      displayMode = "Hard";
    }
    log(displayMode);
    emit(ChangeMode());
  }
}
