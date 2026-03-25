import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:camera/camera.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../image_processing/MediaPicker/file_provider.dart';
import '../../../utilities/image_data.dart';
import '../../../widgets/custom_loader.dart';

class CameraScreen extends StatefulWidget {

  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

  // @override
  // void initState() {
  //   super.initState();
  //    context.read<FileProvider>().initCamera();
  // }
  @override
  Widget build(BuildContext context) {
    final cameraController = context.watch<FileProvider>().controller;
    if (cameraController == null ||
        !cameraController.value.isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CustomLoader.loader()),
      );
    }
    final size = MediaQuery.of(context).size;
    final scale = size.aspectRatio * cameraController.value.aspectRatio;
    return Scaffold(
      body: Stack(
        children: [
          Transform.scale(
            scale: scale < 1 ? 1 / scale : scale,
            child: Center(child: CameraPreview(cameraController)),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 50,
            left: 16,
            child: GestureDetector(
              onTap: () => context.pop(),
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
                  final provider = context.read<FileProvider>();

                  if(provider.isVideo){
                    await provider.recordVideo();
                  }else {
                    await provider.takePicture(context);
                  }
                  if (!context.mounted) return;
                 context.pop();
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
