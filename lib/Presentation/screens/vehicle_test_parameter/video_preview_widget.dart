import 'dart:io';

import 'package:ats_app/Presentation/screens/vehicle_test_parameter/video_dialog_box.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/extension.dart';
import '../../../widgets/custom_text.dart';

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

  // void togglePlayPause(){
  //   if(videoPlayerController!.value.isPlaying){
  //     videoPlayerController!.pause();
  //   }else{
  //     videoPlayerController!.play();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (!videoPlayerController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        VideoPlayer(videoPlayerController!),
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: (){
              showDialog(
                fullscreenDialog: true,
                context: context,
                builder: (context) {
                  return OrientationBuilder(
                    builder: (context, orientation) {
                      return VideoDialog(path: widget.path);
                    }
                  );
                },
              );
            },
            child: Container(
              height: 30,
              width: 30,
             // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.90),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CustomImage(image: playIconImage,scale: 38, color: appColor,)
            ),
          ),
        ),
        // Center(
        //   child: AnimatedOpacity(
        //       opacity: 1.0,
        //       duration: Duration(milliseconds: 200),
        //     child: Icon(videoPlayerController!.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,size: 35.0,
        //       color: Colors.white.withValues(alpha: 0.5),))),

      ],
    );
  }
}
