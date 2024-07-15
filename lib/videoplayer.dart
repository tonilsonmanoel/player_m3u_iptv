import 'package:flutter/material.dart';

import 'package:lecle_yoyo_player/lecle_yoyo_player.dart';

class Videoplayer extends StatefulWidget {
  const Videoplayer({Key? key}) : super(key: key);

  @override
  _VideoplayerState createState() => _VideoplayerState();
}

class _VideoplayerState extends State<Videoplayer> {
  bool fullscreen = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: fullscreen
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(top: 32.0),
              child: YoYoPlayer(
                aspectRatio: 16 / 9,
                url:
                    // 'https://dsqqu7oxq6o1v.cloudfront.net/preview-9650dW8x3YLoZ8.webm',
                    //"https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
                    //"https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
                    "https://cdn.jmvstream.com/w/LVW-8410/LVW8410_uiZOVm6vz1/playlist.m3u8",
                allowCacheFile: true,
                onCacheFileCompleted: (files) {
                  print('Cached file length ::: ${files?.length}');

                  if (files != null && files.isNotEmpty) {
                    for (var file in files) {
                      print('File path ::: ${file.path}');
                    }
                  }
                },
                onCacheFileFailed: (error) {
                  print('Cache file error ::: $error');
                },
                videoStyle: const VideoStyle(
                  qualityStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  forwardAndBackwardBtSize: 30.0,
                  playButtonIconSize: 40.0,
                  enableSystemOrientationsOverride: true,
                  playIcon: Icon(
                    Icons.add_circle_outline_outlined,
                    size: 40.0,
                    color: Colors.white,
                  ),
                  pauseIcon: Icon(
                    Icons.remove_circle_outline_outlined,
                    size: 40.0,
                    color: Colors.white,
                  ),
                  videoQualityPadding: EdgeInsets.all(5.0),
                  // showLiveDirectButton: true,
                  // enableSystemOrientationsOverride: false,
                ),
                videoLoadingStyle: const VideoLoadingStyle(
                  loading: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                        SizedBox(height: 16.0),
                        Text("Loading video..."),
                      ],
                    ),
                  ),
                ),
                autoPlayVideoAfterInit: true,
                onFullScreen: (value) {
                  setState(() {
                    if (fullscreen != value) {
                      fullscreen = value;
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
