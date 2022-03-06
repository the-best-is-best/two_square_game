import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:two_square_game/shared/components.dart/push_page.dart';

import '../../screens/menu.dart';
import '../controller/multi_player_controller.dart';
import '../network/dio_network.dart';

AppBar myAppBar(String title,
    {bool? multiplayer, MultiPlayerController? cubit, BuildContext? context}) {
  return multiplayer == true
      ? AppBar(
          backgroundColor: HexColor("8c3839"),
          title: Text(title),
          leading: IconButton(
              onPressed: () async {
                if (cubit != null) {
                  cubit.logout();
                  await DioHelper.postData(
                      url: "delete/room_delete.php",
                      query: {"roomId": cubit.idRoom()});
                }
                pushReplacementAll(
                  context: context!,
                  widget: const Menu(),
                );
              },
              icon: const Icon(Icons.arrow_back_rounded)),
        )
      : AppBar(
          backgroundColor: HexColor("8c3839"),
          title: Text(title),
        );
}
