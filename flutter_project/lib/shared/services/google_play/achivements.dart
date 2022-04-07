import 'dart:developer';

import 'package:games_services/games_services.dart';
import 'package:play_game_service/play_game_service.dart';

void openAchivement() async {
  await PlayGameService.signIn(scopeSnapShot: true);

  PlayGameService.showAchievements();
}

void submitArchivemetScore(
    {required String achivementId, required bool isInc}) async {
  await PlayGameService.signIn(scopeSnapShot: true);
  if (!isInc) {
    GamesServices.signIn().then((value) => GamesServices.unlock(
            achievement: Achievement(
          androidID: achivementId,
        )).then((value) => GamesServices.signOut()));
  } else {
    PlayGameService.signIn()
        .then((value) => PlayGameService.increment(achivementId));
  }
}
