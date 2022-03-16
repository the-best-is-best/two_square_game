import 'package:flutter/material.dart';

import '../../screens/menu.dart';
import '../cubit/multi_player_controller.dart';

void backClickedMultiPlayer(MultiPlayercubit cubit, BuildContext context) {
  if (cubit.idRoom() != null) {
    cubit.logout();
  }
  if (!cubit.gameStareted()) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const Menu(),
      ),
      (route) => false,
    );
  }
}
