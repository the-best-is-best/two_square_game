import 'package:play_game_service/play_game_service.dart';

void openLeaderBoard() async {
  await PlayGameService.signIn(scopeSnapShot: false);

  PlayGameService.showLeaderboards();
}

void submitScore({required String leaderBoardId, required double score}) async {
  await PlayGameService.signIn(scopeSnapShot: false);

  PlayGameService.submitScore(leaderBoardId, score.round());
}
