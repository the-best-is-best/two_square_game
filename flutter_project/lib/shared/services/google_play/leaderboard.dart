import 'package:games_services/games_services.dart';

void openLeaderBoard() async {
  if (!await GamesServices.isSignedIn) {
    GamesServices.signIn().then((value) => GamesServices.showLeaderboards(
        androidLeaderboardID: 'CgkI79uKhO8LEAIQAg'));
  } else {
    GamesServices.showLeaderboards(androidLeaderboardID: 'CgkI79uKhO8LEAIQAg');
  }
}

void submitScore(double score) {
  GamesServices.submitScore(
    score:
        Score(androidLeaderboardID: 'CgkI79uKhO8LEAIQAg', value: score.round()),
  );
}
