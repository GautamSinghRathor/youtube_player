import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: YoutubeScreen(),
    );
  }
}

class YoutubeScreen extends StatefulWidget {
  YoutubeScreen({Key key}) : super(key: key);

  @override
  _YoutubeScreenState createState() => _YoutubeScreenState();
}

class _YoutubeScreenState extends State<YoutubeScreen> {
  YoutubePlayerController controller;

  @override
  void initState() {
    controller = YoutubePlayerController(
      initialVideoId: 'nPt8bK2gbaU',
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        privacyEnhanced: true,
      ),
    );

    controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    };

    controller.onExitFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      Future.delayed(Duration(seconds: 1), () {
        controller.play();
      });
      Future.delayed(const Duration(seconds: 5), () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      });
      log('Exited FullScreen');
    };
    super.initState();
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame(
      aspectRatio: 16 / 9,
    );
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Youtube Player'),
        ),
        body: YoutubePlayerControllerProvider(
          controller: controller,
          child: YoutubeValueBuilder(
            controller: controller,
            builder: (context, value) {
              return ListView(
                children: [
                  player,
                  playPauseButtonBar(value, context),
                  // Controls(),
                ],
              );
            },
          ),
        )
        // YoutubePlayerControllerProvider(
        //   controller: controller,
        //   child: ListView(
        //     children: [
        //       player,
        //       Controls(),
        //     ],
        //   ),
        // ),
        );
  }
}

class Controls extends StatelessWidget {
  ///
  const Controls();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _space,
          // MetaDataSection(),
          // _space,
          // SourceInputSection(),
          // _space,
          // PlayPauseButtonBar(),
          // _space,
          // VolumeSlider(),
          // _space,
          // PlayerStateSection(),
        ],
      ),
    );
  }
}

Widget playPauseButtonBar(var value, BuildContext context) {
  return Row(
    children: [
      IconButton(
        icon: Icon(
          value.playerState == PlayerState.playing
              ? Icons.pause
              : Icons.play_arrow,
        ),
        onPressed: value.isReady
            ? () {
                value.playerState == PlayerState.playing
                    ? context.ytController.pause()
                    : context.ytController.play();
              }
            : null,
      ),
    ],
  );
}

Widget get _space => const SizedBox(height: 10);
