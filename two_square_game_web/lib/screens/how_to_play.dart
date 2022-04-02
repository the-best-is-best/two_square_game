import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbib_style/style/font_style.dart';
import 'package:video_player/video_player.dart';

import '../shared/components.dart/app_bar.dart';

class HowToPlay extends StatefulWidget {
  const HowToPlay({Key? key}) : super(key: key);

  @override
  State<HowToPlay> createState() => _HowToPlayState();
}

class _HowToPlayState extends State<HowToPlay> {
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset("assets/video/how-to-play.mp4");

  @override
  void initState() {
    _videoPlayerController.setVolume(1);
    _videoPlayerController.addListener(() {
      setState(() {});
    });
    _videoPlayerController.initialize().then((_) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _audioController() async {
    if (_videoPlayerController.value.isPlaying) {
      await _videoPlayerController.pause();
    } else {
      await _videoPlayerController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('How to play', context: context),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _videoPlayerController.value.isInitialized
                      ? SizedBox(
                          width: 50.w,
                          height: 520.h,
                          child: AspectRatio(
                            aspectRatio:
                                _videoPlayerController.value.aspectRatio,
                            child: Stack(
                              children: [
                                VideoPlayer(_videoPlayerController),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: 220.w,
                                    height: 40.h,
                                    color: Colors.grey.withOpacity(.5),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        onPressed: () => _audioController(),
                                        icon: Icon(
                                            _videoPlayerController
                                                    .value.isPlaying
                                                ? Icons.pause_circle
                                                : Icons.play_circle,
                                            size: 30.h,
                                            color: const Color.fromRGBO(
                                                206, 222, 235, .5)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      """You can play Choose Two Squares single or multiplayer game with 2 players or more.
        
HOW TO PLAY :

          first you have to choose two adjacent numbers like (in easy mode) 3 and 4, or 3 and 7, then it will be the other player turn.
The goal is to play the last two adjacent numbers while there are blocked numbers that don't have an adjacent number.
""",
                      style: TBIBFontStyle.h5,
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
