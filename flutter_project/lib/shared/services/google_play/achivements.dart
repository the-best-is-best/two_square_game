import 'package:tbib_gms_google_play/tbib_gms_google_play.dart';

void openAchivement() async {
  if (!await TBIBGMSGooglePlay.isSignedIn) {
    await TBIBGMSGooglePlay.signIn();
  }

  TBIBGMSGooglePlay.showAchievements();
}

Future submitArchivemetScore(
    {required String achivementId, required bool isInc}) async {
  if (!await TBIBGMSGooglePlay.isSignedIn) {
    await TBIBGMSGooglePlay.signIn();
  }

  if (!isInc) {
    TBIBGMSGooglePlay.unlock(
      achievement: Achievement(androidID: achivementId),
    );
  } else {
    TBIBGMSGooglePlay.increment(achivementId);
  }
}
