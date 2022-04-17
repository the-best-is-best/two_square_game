import 'package:games_services/games_services.dart';
import 'dart:developer';

import 'package:play_game_service/play_game_service.dart';

void openLeaderBoard() async {
  await PlayGameService.signIn(scopeSnapShot: true);

  PlayGameService.showLeaderboards();
}

Future submitLeaderBoardScore(
    {required String leaderBoardId, required int score}) async {
  log("leaderBoardId : " + leaderBoardId + " " + score.toString());
  try {
    bool isLogin = await GamesServices.isSignedIn;
    if (!isLogin) {
      await GamesServices.signIn();
    }
    // await GamesServices.submitScore(
    //     score: Score(androidLeaderboardID: leaderBoardId, value: score));
    // //PlayGameService.signIn(scopeSnapShot: true) .then((value) =>
    PluginResult result = await PlayGameService.signIn(scopeSnapShot: true);
    log(result.success.toString());
    PluginResult res = await PlayGameService.submitScore(leaderBoardId, score);
    log("submiting  ${res.message}");
  } catch (ex) {
    log("EX 1 ${ex.toString()}");
  }
  log("End of Trying to submit");
}
