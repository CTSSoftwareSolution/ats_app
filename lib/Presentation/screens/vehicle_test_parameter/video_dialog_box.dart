import 'dart:io';

import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';




class VideoDialog extends StatefulWidget {
  final String path;

  const VideoDialog({super.key, required this.path});

  @override
  State<VideoDialog> createState() => _VideoDialogState();
}

class _VideoDialogState extends State<VideoDialog> {
  late VideoPlayerController controller;
  bool isInitialized = false;


  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.file(File(widget.path));

    controller.initialize().then((_) {

      setState(() {
        isInitialized = true;
      });
      controller.play();
    });

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void togglePlayPause() {
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(10),
      child: isInitialized ?
      OrientationBuilder(
        builder: (context, orientation) {
          return SizedBox(
            width: orientation == Orientation.landscape
                ? MediaQuery.of(context).size.width * 0.9
                : MediaQuery.of(context).size.width * 0.95,
            height: orientation == Orientation.landscape
                ? MediaQuery.of(context).size.height * 0.6
                : MediaQuery.of(context).size.height * 0.8,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller)),

                GestureDetector(
                  onTap: togglePlayPause,
                  child: Icon(
                    controller.value.isPlaying
                        ? Icons.pause_circle
                        : Icons.play_circle,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  top: 10.0,
                  right: 10.0,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cameraBackConColor,
                    ),
                    child: IconButton(
                      icon: ImageIcon(
                        AssetImage(closeIcon),
                        color: whiteColor,
                        size: 10,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      )
          : const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}