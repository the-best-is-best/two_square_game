import 'package:games_services/games_services.dart';

void openAchivement() async {
  if (!await GamesServices.isSignedIn) {
    GamesServices.signIn().then((value) => GamesServices.showAchievements());
  } else {
    GamesServices.showAchievements();
  }
}
