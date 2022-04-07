import 'dart:developer';
import 'dart:typed_data';

import 'package:play_game_service/play_game_service.dart';
import 'package:two_square_game/shared/models/your_data.dart';

void saveDataGooglePaly() async {
  await PlayGameService.signIn(scopeSnapShot: true);
  Uint8List data = Uint8List(4);
  data[0] = YourData.score;
  data[1] = YourData.winMedium3;
  data[2] = YourData.winHard3;
  data[3] = YourData.winHard4;

  var ret = await PlayGameService.saveSnapShot("save1", data, "YourData");

  if (ret.success) {
    LoadSnapshotResult snapshotResult =
        await PlayGameService.loadSnapShot("save1");
    log(snapshotResult.data.toString());
  } else {
    log(ret.message.toString());
  }
}

void loadDataGooglePlay() async {
  LoadSnapshotResult snapshotResult =
      await PlayGameService.loadSnapShot("save1");
  if (snapshotResult.data != null) {
    Uint8List data = snapshotResult.data!;

    YourData.score = data[0];
    YourData.winMedium3 = data[1];
    YourData.winHard3 = data[2];
    YourData.winHard4 = data[3];
  }
}
