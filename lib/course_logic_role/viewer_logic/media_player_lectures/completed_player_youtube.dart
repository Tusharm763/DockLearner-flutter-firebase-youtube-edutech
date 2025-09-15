import 'dart:async';
import 'package:flutter/material.dart';
import 'package:widget_zoom/widget_zoom.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme_set/theme_colors.dart';

class YoutubePlayerCompletedPage extends StatefulWidget {
  const YoutubePlayerCompletedPage({
    super.key,
    required this.courseTitle,
    required this.lectureIndexInId,
    required this.noOfLecture,
    required this.idYoutube,
  });

  final String idYoutube;
  final String courseTitle;
  final int lectureIndexInId;
  final int noOfLecture;

  @override
  State<YoutubePlayerCompletedPage> createState() => _YoutubePlayerCompletedPageState();
}

class _YoutubePlayerCompletedPageState extends State<YoutubePlayerCompletedPage> with SingleTickerProviderStateMixin {
  late YoutubePlayerController _controller;
  int currentSeconds = 0;
  int youtubeSeekDisplay = 0;
  int totalDuration = 0;
  Map<String, String> videoInformation = {"Title": "", "Author": "", "Open": ""};

  final int seekThreshold = 4;
  Timer? _positionTimer;
  bool isPlaying = false;
  PlayerState currentPlayerState = PlayerState.unknown;
  bool _isDisposed = false;

  @override
  void initState() {
    // currentSeconds = widget.startFrom;
    // youtubeSeekDisplay = widget.startFrom;
    // previousSeconds = widget.startFrom - 1;
    // debugPrint("\nAutoPlay : ${widget.autoPlayVideo}");
    // debugPrint("\nAutoSave : ${widget.autoSaving}");
    super.initState();
    initializeYoutubeController();
  }

  @override
  void dispose() {
    _controller.pauseVideo();
    _controller.stopVideo();

    super.dispose();
  }

  Future<void> initializeYoutubeController() async {
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.idYoutube,
      // startSeconds: widget.startFrom.toDouble(),
      params: const YoutubePlayerParams(
        showControls: false,
        enableCaption: false,
        showVideoAnnotations: false,
        mute: false,
        showFullscreenButton: false,
        loop: false,
      ),
      autoPlay: true, //widget.autoPlayVideo,
    );

    if (!_isDisposed) {
      _controller.listen((event) {
        if (!_isDisposed) {
          setState(() {
            currentPlayerState = event.playerState;

            if (event.playerState == PlayerState.playing) {
              if (!isPlaying) {
                isPlaying = true;
                startPositionTimer();
              }
            } else if (event.playerState == PlayerState.paused || event.playerState == PlayerState.ended) {
              isPlaying = false;
              _positionTimer?.cancel();
            }
          });
        }
      });
    }
  }

  void startPositionTimer() {
    _positionTimer?.cancel();
    _positionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isPlaying && !_isDisposed) {
        _controller.duration.then((value) {
          setState(() {
            totalDuration = value.round();
          });
        });

        _controller.videoData.then((value) {
          if (videoInformation["Title"] == "") {
            setState(() {
              videoInformation["Title"] = value.title.toString();
              videoInformation["Author"] = value.author.toString();
              videoInformation["Open"] = value.videoId.toString();
            });
          }
        });

        _controller.currentTime.then((value) {
          if (!_isDisposed) {
            setState(() {
              debugPrint("\n\n\n\n\n$value\n\n\n\n\n");
              // previousSeconds = currentSeconds;
              youtubeSeekDisplay = value.round();
              // if (value.round() >= previousSeconds.round()) {
              // previousSeconds++;
              currentSeconds++;
              // } else {
              // previousSeconds = previousSeconds;
              // currentSeconds = currentSeconds;
              // }
            });
          }
        });
      }
    });
  }

  String _getPlayerStateText() {
    switch (currentPlayerState) {
      case PlayerState.playing:
        return "Playing";
      case PlayerState.paused:
        return "Paused";
      case PlayerState.buffering:
        return "Buffering";
      case PlayerState.ended:
        return "Ended";
      case PlayerState.unStarted:
        return "Not Started";
      default:
        return "Unknown";
    }
  }

  bool isPlayed = false;

  Future<void> _launchYouTubeVideo() async {
    final Uri youtubeUrl = Uri.parse('https://www.youtube.com/watch?v=${widget.idYoutube}');

    try {
      if (await canLaunchUrl(youtubeUrl)) {
        _controller.pauseVideo();
        await launchUrl(youtubeUrl, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch YouTube');
      }
    } catch (e) {
      debugPrint('Error launching YouTube: $e');
    }
  }

  Widget displayVideoInformation({required String textPrimary, required String textSecondary}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: textPrimary,
                style: AppTheme.t6TitleSmall(context)?.copyWith(letterSpacing: 1.25, fontWeight: FontWeight.w600, color: AppTheme.onPrimary),
              ),
              TextSpan(
                text: textSecondary,
                style: AppTheme.t5TitleMedium(context)?.copyWith(letterSpacing: 1.25, fontWeight: FontWeight.w800, color: AppTheme.onPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  secondsToHHMMSS(sec) {
    int hours = sec ~/ 3600;
    int minutes = (sec % 3600) ~/ 60;
    int secs = sec % 60;
    if (hours == 0 && minutes == 0) {
      String minutesStr = minutes.toString().padLeft(2, '0');
      String secondsStr = secs.toString().padLeft(2, '0');

      return "$minutesStr:$secondsStr";
    }

    if (hours == 0) {
      String minutesStr = minutes.toString().padLeft(2, '0');
      String secondsStr = secs.toString().padLeft(2, '0');
      return "$minutesStr:$secondsStr";
    }

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = secs.toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pCon,
      body: SafeArea(
        child: WidgetZoom(
          heroAnimationTag: 'tag_1',
          zoomWidget: Stack(
            children: [
              const BackGroundWithGradientEffect(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 75.0, 0.0, 0.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 90.0,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.55,
                        width: MediaQuery.sizeOf(context).height,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.5),
                          child: Stack(
                            children: [
                              Container(
                                height: MediaQuery.sizeOf(context).height * 0.55 - 5,
                                width: MediaQuery.sizeOf(context).height,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: AppTheme.primary),
                                child: YoutubePlayer(controller: _controller, aspectRatio: 16 / 9),
                              ),
                              (_getPlayerStateText() == "Ended")
                                  ? Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: AppTheme.primary),
                                      height: MediaQuery.sizeOf(context).height * 0.55 - 5,
                                      width: MediaQuery.sizeOf(context).height,
                                      child: Align(
                                        alignment: (_getPlayerStateText() == "Not Started") ? Alignment.bottomCenter : Alignment.center,
                                        child: Padding(
                                          padding: (_getPlayerStateText() == "Not Started") ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
                                          child: Text(
                                            (_getPlayerStateText() == "Ended")
                                                ? "100 % Completed"
                                                : "Something Went Wrong....\n\nMay be beacuse this Video is No Longer Available on Youtube.\nPlease Contact/Mail the Admin Supports.\n",
                                            style: TextStyle(
                                              fontSize: (_getPlayerStateText() == "Not Started") ? 9.0 : 18,
                                              color: Colors.white,
                                              fontWeight: (_getPlayerStateText() == "Not Started") ? FontWeight.w600 : FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : (_getPlayerStateText() == "Unknown")
                                  ? (_getPlayerStateText() == "Buffering")
                                        ? Container(
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: AppTheme.primary),
                                            height: MediaQuery.sizeOf(context).height * 0.55 - 5,
                                            width: MediaQuery.sizeOf(context).height,
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CircularProgressIndicator(color: AppTheme.onPrimary),
                                                  Text(
                                                    "Loading...",
                                                    style: AppTheme.t5TitleMedium(
                                                      context,
                                                    )!.copyWith(color: AppTheme.primary, letterSpacing: 1.25, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () => isPlaying ? _controller.pauseVideo() : _controller.playVideo(),
                                            child: Container(
                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: AppTheme.primary),
                                              height: MediaQuery.sizeOf(context).height * 0.55 - 5,
                                              width: MediaQuery.sizeOf(context).height,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(5.0),
                                                      decoration: const BoxDecoration(
                                                        gradient: RadialGradient(colors: [Colors.transparent, Colors.transparent]),
                                                      ),
                                                      child: Icon(Icons.play_arrow, color: AppTheme.onPrimary, size: 40.0),
                                                    ),
                                                    RichText(
                                                      textAlign: TextAlign.center,
                                                      text: TextSpan(
                                                        text: "Please Wait...",
                                                        style: AppTheme.t6TitleSmall(
                                                          context,
                                                        )!.copyWith(color: AppTheme.onPrimary, letterSpacing: 1.25, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                  : Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(3.0, 3.00, 3.0, 7.5),
                                        child: Card(
                                          color: AppTheme.primary,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    isPlaying ? _controller.pauseVideo() : _controller.playVideo();
                                                  },
                                                  child: Card(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: (_getPlayerStateText() == "Unknown" || _getPlayerStateText() == "UnStarted")
                                                          ? const Text("Start", style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold))
                                                          : isPlaying
                                                          ? Icon(
                                                              Icons.pause,
                                                              size: AppTheme.t4TitleLarge(context)!.fontSize! + 5,
                                                              color: AppTheme.primary,
                                                            )
                                                          : (_getPlayerStateText() == "Unknown" || _getPlayerStateText() == "Buffering")
                                                          ? RichText(
                                                              textAlign: TextAlign.center,
                                                              text: TextSpan(
                                                                text: "Loading...",
                                                                style: AppTheme.t5TitleMedium(context)!.copyWith(
                                                                  color: AppTheme.primary,
                                                                  letterSpacing: 1.25,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            )
                                                          : Icon(
                                                              Icons.play_arrow,
                                                              size: AppTheme.t4TitleLarge(context)!.fontSize! + 5,
                                                              color: AppTheme.primary,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const Expanded(child: SizedBox(width: 1.5)),
                                              Card(
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: RichText(
                                                      textAlign: TextAlign.center,
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: (currentSeconds > 0 && totalDuration > 0)
                                                                ? "${secondsToHHMMSS(youtubeSeekDisplay.round()) ?? 0} / ${secondsToHHMMSS(totalDuration.round()) ?? 0}"
                                                                : "${secondsToHHMMSS(0)} / --:--",
                                                            style: AppTheme.t5TitleMedium(
                                                              context,
                                                            )!.copyWith(color: AppTheme.primary, letterSpacing: 1.25, fontWeight: FontWeight.bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(3.0, 3.0, 3.0, 7.5),
                                  child: Card(
                                    color: AppTheme.primary,
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height: AppTheme.screenHeightInPortrait(context) * 0.035,
                                          width: AppTheme.screenWidthInPortrait(context),
                                          child: Center(
                                            child: RichText(
                                              textAlign: TextAlign.left,
                                              text: TextSpan(
                                                children: [TextSpan(text: widget.courseTitle.toString())],
                                                style: AppTheme.t5TitleMedium(
                                                  context,
                                                )!.copyWith(color: AppTheme.primary, letterSpacing: 1.25, fontWeight: FontWeight.bold),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(7.5, 2.50, 7.5, 10.0),
                          child: Card(
                            color: AppTheme.primary,
                            child: (videoInformation["Title"].toString().isNotEmpty)
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(12.5, 12.50, 12.5, 7.50),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "About",
                                              style: AppTheme.t6TitleSmall(context)?.copyWith(
                                                letterSpacing: 1.25,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context).colorScheme.onPrimary,
                                              ),
                                            ),
                                            const Expanded(child: SizedBox(width: 1.0)),
                                            SizedBox(
                                              height: 30.0,
                                              width: 30.0,
                                              child: Image.asset("files/images/youtube_logo.png", color: Colors.red),
                                            ),
                                            const SizedBox(width: 7.5),
                                            Text(
                                              "Youtube ",
                                              style: AppTheme.t6TitleSmall(
                                                context,
                                              )?.copyWith(letterSpacing: 1.25, fontWeight: FontWeight.w600, color: AppTheme.onPrimary),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                _launchYouTubeVideo();
                                              },
                                              child: Container(
                                                child: Icon(Icons.open_in_new, color: Colors.blue, size: AppTheme.t4TitleLarge(context)!.fontSize!),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(color: AppTheme.onPrimary, thickness: 2.5),
                                      SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            displayVideoInformation(textPrimary: "Title:  ", textSecondary: videoInformation["Title"] ?? ""),
                                            displayVideoInformation(
                                              textPrimary: "Channel/Author:  ",
                                              textSecondary: videoInformation["Author"] ?? "",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(12.5, 12.50, 12.5, 7.50),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 30.0,
                                              width: 30.0,
                                              child: Image.asset("files/images/youtube_logo.png", color: Colors.red),
                                            ),
                                            const SizedBox(width: 7.5),
                                            Text(
                                              "Youtube",
                                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                fontFamily: 'SourGummy',
                                                letterSpacing: 1.25,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context).colorScheme.onPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //TODO: APPBAR-CARD here is written in context to WILL-POP-SCOPE.
              Builder(
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 010.0, left: 10.0, right: 10.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Card(
                                      elevation: 5.0,
                                      child: SizedBox(
                                        height: Theme.of(context).textTheme.displayMedium?.fontSize,
                                        width: Theme.of(context).textTheme.displayMedium?.fontSize,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Center(child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Card(
                                    elevation: 5.0,
                                    child: SizedBox(
                                      height: Theme.of(context).textTheme.displayMedium?.fontSize,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(18.0, 10.0, 15.0, 10.0),
                                        child: Center(
                                          child: Text(
                                            "Part: ${widget.lectureIndexInId + 1} / ${widget.noOfLecture}",
                                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              fontFamily: 'SourGummy',
                                              letterSpacing: 1.25,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context).colorScheme.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
