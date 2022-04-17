import 'package:games_services/games_services.dart';
import 'package:play_game_service/play_game_service.dart';

void openAchivement() async {
  await PlayGameService.signIn(scopeSnapShot: true);

  PlayGameService.showAchievements();
}

Future submitArchivemetScore(
    {required String achivementId, required bool isInc}) async {
  if (!isInc) {
    GamesServices.unlock(
        achievement: Achievement(
      androidID: achivementId,
    ));
  } else {
    PlayGameService.increment(achivementId);
  }
}
