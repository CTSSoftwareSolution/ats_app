import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewWidget extends StatefulWidget {
  final String path;
  const VideoPreviewWidget({super.key, required this.path});

  @override
  State<VideoPreviewWidget> createState() => _VideoPreviewWidgetState();
}

class _VideoPreviewWidgetState extends State<VideoPreviewWidget> {

  VideoPlayerController? videoPlayerController;


  @override
  void initState() {
    super.initState();

    videoPlayerController = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        setState(() {});
      });

    videoPlayerController!.addListener((){
      setState(() {});
    });
  }

  void togglePlayPause(){
    if(videoPlayerController!.value.isPlaying){
      videoPlayerController!.pause();
    }else{
      videoPlayerController!.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!videoPlayerController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return GestureDetector(
      onTap: togglePlayPause,
      child: Stack(
        fit: StackFit.expand,
        children: [
          VideoPlayer(videoPlayerController!),
          Center(
            child: AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(milliseconds: 200),
              child: Icon(videoPlayerController!.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,size: 35.0,color: Colors.white.withValues(alpha: 0.5),))),

        ],
      ),
    );
  }
}
