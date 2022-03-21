import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbib_style/style/font_style.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../shared/components.dart/app_bar.dart';

class HowToPlay extends StatefulWidget {
  const HowToPlay({Key? key}) : super(key: key);

  @override
  State<HowToPlay> createState() => _HowToPlayState();
}

class _HowToPlayState extends State<HowToPlay> {
  final YoutubePlayerController _controllerYoutube = YoutubePlayerController(
    initialVideoId: '51tBJRncZnI',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controllerYoutube.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('How to play', context: context),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 520.h,
                  child: YoutubePlayer(
                    controller: _controllerYoutube,
                    showVideoProgressIndicator: true,
                    bottomActions: const [],
                    topActions: const [],
                    aspectRatio: 16 / 9,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    """You can't play Choose Two Squares alone, it's an online  multiplayer game or 2 player offline game.
        
         HOW TO PLAY :
                  first you have to choose two adjacent numbers like (in easy mode) 3 and 4, or 3 and 7, then it will be the other player turn.
         The goal is to play the last two adjacent numbers while there are blocked numbers that don't have an adjacent number.
        """,
                    style: TBIBFontStyle.h5,
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
