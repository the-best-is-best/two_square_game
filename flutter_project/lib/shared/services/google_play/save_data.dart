import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:play_game_service/play_game_service.dart';
import 'package:two_square_game/shared/models/your_data.dart';

Future saveDataGooglePaly() async {
  await PlayGameService.signIn(scopeSnapShot: true);

  Map yourDataMap = YourData.toMap();
  String yourData = json.encode(yourDataMap);
  List<int> bytesList = utf8.encode(yourData);

  Uint8List data = Uint8List.fromList(bytesList);

  PluginResult res =
      await PlayGameService.saveSnapShot("save1", data, "YourData");
}

void loadDataGooglePlay() async {
  LoadSnapshotResult snapshotResult =
      await PlayGameService.loadSnapShot("save1");
  if (snapshotResult.data != null) {
    try {
      Uint8List data = snapshotResult.data!;
      String bytes = utf8.decode(data);
      Map yourDataMap = json.decode(bytes);
      YourData.score = yourDataMap["score"];
      YourData.winMedium3 = yourDataMap["winMedium3"];
      YourData.winHard3 = yourDataMap["winHard3"];
      YourData.winHard4 = yourDataMap["winHard4"];
      log(YourData.score.toString());
    } catch (_) {}
  }
}
