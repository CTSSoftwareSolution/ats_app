import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/image_data.dart';
import '../../../widgets/custom_loader.dart';
import '../../provider/MediaPicker/file_provider.dart';

class CameraScreen extends StatelessWidget {

  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);
    if (fileProvider.controller == null ||
        !fileProvider.controller!.value.isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CustomLoader.loader()),
      );
    }
    final size = MediaQuery.of(context).size;
    final scale = size.aspectRatio * fileProvider.controller!.value.aspectRatio;
    return Scaffold(
      body: Stack(
        children: [
          Transform.scale(
            scale: scale < 1 ? 1 / scale : scale,
            child: Center(child: CameraPreview(fileProvider.controller!)),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 50,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 45.0,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cameraBackConColor,
                  shape: BoxShape.circle,
                ),
                child: CustomImage(image: backArrowIcon, scale: 3.5),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  await fileProvider.takePicture(context);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                child: CustomImage(image: cameraButtonIcon, scale: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
