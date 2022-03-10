import 'package:flutter/material.dart';

import '../../screens/menu.dart';
import '../controller/multi_player_controller.dart';

void backClickedMultiPlayer(MultiPlayerController cubit, BuildContext context) {
  // cubit.closeAd();
  if (cubit.idRoom() != null) {
    cubit.logout();
  }
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => const Menu(),
    ),
    (route) => false,
  );
}
