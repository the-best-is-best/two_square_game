import 'dart:developer';

import 'package:tbib_gms_google_play/tbib_gms_google_play.dart';

void openLeaderBoard() async {
  await TBIBGMSGooglePlay.signIn();

  TBIBGMSGooglePlay.showLeaderboards();
}

Future submitLeaderBoardScore(
    {required String leaderBoardId, required int score}) async {
  log("leaderBoardId : " + leaderBoardId + " " + score.toString());
  try {
    bool isLogin = await TBIBGMSGooglePlay.isSignedIn;
    if (!isLogin) {
      await TBIBGMSGooglePlay.signIn();
    }
    PluginResult res =
        await TBIBGMSGooglePlay.submitScore(leaderBoardId, score);
    log("submiting  ${res.message}");
  } catch (ex) {
    log("EX 1 ${ex.toString()}");
  }
  log("End of Trying to submit");
}
