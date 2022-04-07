import 'package:play_game_service/play_game_service.dart';

void openLeaderBoard() async {
  await PlayGameService.signIn(scopeSnapShot: true);

  PlayGameService.showLeaderboards();
}

void submitLeaderBoardScore(
    {required String leaderBoardId, required double score}) async {
  await PlayGameService.signIn(scopeSnapShot: true);

  PlayGameService.submitScore(leaderBoardId, score.round());
}
