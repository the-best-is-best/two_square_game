import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:tbib_gms_google_play/tbib_gms_google_play.dart';
import 'package:two_square_game/shared/models/your_data.dart';

Future saveDataGooglePaly() async {
  await TBIBGMSGooglePlay.signIn();

  Map yourDataMap = YourData.toMap();

  var res =
      await TBIBGMSGooglePlay.saveSnapShot("save1", yourDataMap, "YourData");
  print(res.success);
}

Future<bool> loadDataGooglePlay() async {
  print("get data");
  LoadSnapshotResult snapshotResult =
      await TBIBGMSGooglePlay.loadSnapShot("save1");
  if (snapshotResult.data != null) {
    Map yourDataMap = snapshotResult.data!;
    YourData.score = yourDataMap["score"];
    YourData.winMedium3 = yourDataMap["winMedium3"];
    YourData.winHard3 = yourDataMap["winHard3"];
    YourData.winHard4 = yourDataMap["winHard4"];
    log("score :" + YourData.score.toString());
    //BotToast.showText(text: "score :" + YourData.score.toString());
    return true;
  } else {
    log("err" + snapshotResult.message.toString());
    return false;
  }
}
