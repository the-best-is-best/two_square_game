import 'package:play_game_service/play_game_service.dart';

void openAchivement() async {
  await PlayGameService.signIn(scopeSnapShot: false);

  PlayGameService.showAchievements();
}
