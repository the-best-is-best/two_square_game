import 'package:two_square_game/shared/services/google_play/leaderboard.dart';

import '../../models/your_data.dart';

void achivLeader({required double mode, required int numberOfPlayer}) {
  submitScore(
      leaderBoardId: "CgkI79uKhO8LEAIQAg", score: YourData.score.toDouble());

  if (mode == 2 && numberOfPlayer == 3) {
    YourData.winMedium3 += 1;
    submitScore(
        leaderBoardId: "CgkI79uKhO8LEAIQBQ",
        score: YourData.winMedium3.toDouble());
  } else if (mode == 3 && numberOfPlayer == 3) {
    YourData.winHard3 += 1;
    submitScore(
        leaderBoardId: "CgkI79uKhO8LEAIQBg",
        score: YourData.winHard3.toDouble());
  } else if (mode == 3 && numberOfPlayer == 4) {
    YourData.winHard4 += 1;
    submitScore(
        leaderBoardId: "CgkI79uKhO8LEAIQBw",
        score: YourData.winHard4.toDouble());
  }
}
