import 'package:two_square_game/shared/services/google_play/leaderboard.dart';

import '../../models/your_data.dart';
import 'achivements.dart';

Future achivLeader({required double mode, required int numberOfPlayer}) async {
  submitLeaderBoardScore(
      leaderBoardId: "CgkI79uKhO8LEAIQFA", score: YourData.score);
  if (mode == 1) {
    await submitArchivemetScore(
        achivementId: "CgkI79uKhO8LEAIQCA", isInc: false);
  }
  if (mode == 2 && numberOfPlayer == 3) {
//    print(YourData.winMedium3);
    YourData.winMedium3 += 1;

    await submitLeaderBoardScore(
        leaderBoardId: "CgkI79uKhO8LEAIQFQ", score: YourData.winMedium3);
    await submitArchivemetScore(
        achivementId: "CgkI79uKhO8LEAIQCQ", isInc: false);
    await submitArchivemetScore(
        achivementId: "CgkI79uKhO8LEAIQDA", isInc: true);
  } else if (mode == 3 && numberOfPlayer == 3) {
    YourData.winHard3 += 1;

    await submitLeaderBoardScore(
        leaderBoardId: "CgkI79uKhO8LEAIQEg", score: YourData.winHard3);

    await submitArchivemetScore(
        achivementId: "CgkI79uKhO8LEAIQCg", isInc: false);
    await submitArchivemetScore(
        achivementId: "CgkI79uKhO8LEAIQDQ", isInc: true);
  } else if (mode == 3 && numberOfPlayer == 4) {
    YourData.winHard4 += 1;
    await submitLeaderBoardScore(
        leaderBoardId: "CgkI79uKhO8LEAIQEw", score: YourData.winHard4);

    await submitArchivemetScore(
        achivementId: "CgkI79uKhO8LEAIQCw", isInc: false);
    await submitArchivemetScore(
        achivementId: "CgkI79uKhO8LEAIQDg", isInc: true);
    await submitArchivemetScore(
        achivementId: "CgkI79uKhO8LEAIQDw", isInc: true);
  }
}
