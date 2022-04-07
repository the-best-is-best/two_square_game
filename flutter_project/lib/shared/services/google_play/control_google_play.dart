import 'package:two_square_game/shared/services/google_play/leaderboard.dart';

import '../../models/your_data.dart';
import 'achivements.dart';

void achivLeader({required double mode, required int numberOfPlayer}) {
  submitLeaderBoardScore(
      leaderBoardId: "CgkI79uKhO8LEAIQAg", score: YourData.score.toDouble());
  if (mode == 1) {
    submitArchivemetScore(achivementId: "CgkI79uKhO8LEAIQCA", isInc: false);
  }
  if (mode == 2 && numberOfPlayer == 3) {
    YourData.winMedium3 += 1;
    submitLeaderBoardScore(
        leaderBoardId: "CgkI79uKhO8LEAIQBQ",
        score: YourData.winMedium3.toDouble());
    submitArchivemetScore(achivementId: "CgkI79uKhO8LEAIQCQ", isInc: false);
    submitArchivemetScore(achivementId: "CgkI79uKhO8LEAIQDA", isInc: true);
  } else if (mode == 3 && numberOfPlayer == 3) {
    YourData.winHard3 += 1;

    submitLeaderBoardScore(
        leaderBoardId: "CgkI79uKhO8LEAIQBg",
        score: YourData.winHard3.toDouble());

    submitArchivemetScore(achivementId: "CgkI79uKhO8LEAIQCg", isInc: false);
    submitArchivemetScore(achivementId: "CgkI79uKhO8LEAIQDA", isInc: true);
  } else if (mode == 3 && numberOfPlayer == 4) {
    YourData.winHard4 += 1;
    submitLeaderBoardScore(
        leaderBoardId: "CgkI79uKhO8LEAIQBw",
        score: YourData.winHard4.toDouble());

    submitArchivemetScore(achivementId: "CgkI79uKhO8LEAIQCw", isInc: false);
    submitArchivemetScore(achivementId: "CgkI79uKhO8LEAIQDg", isInc: true);
    submitArchivemetScore(achivementId: "CgkI79uKhO8LEAIQDw", isInc: true);
  }
}
