import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'states/menu_states.dart';

class Menucubit extends Cubit<MenuStates> {
  Menucubit() : super(MenuInitialStates());
  static Menucubit get(context) => BlocProvider.of(context);

  int boardSize = 4;
  String displayMode = "Easy";
  bool multiClicked = false;

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

  void multiPlayerClick(bool clicked) {
    multiClicked = clicked;
    emit(MultiPlayerClicked());
  }
}
