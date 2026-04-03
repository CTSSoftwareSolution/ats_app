import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:camera/camera.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../image_processing/MediaPicker/file_provider.dart';
import '../../../utilities/extension.dart';
import '../../../utilities/image_data.dart';
import '../../../widgets/custom_loader.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
   // FileProvider? provider;

  // @override
  // void initState() {
  //   super.initState();
  //   final provider = context.read<FileProvider>();
  //   WidgetsBinding.instance.addObserver(this);
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     await provider.initCamera();
  //   });
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      context.read<FileProvider>().disposeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final provider = Provider.of<FileProvider>(context,listen: false);
    provider.disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileProvider = context.watch<FileProvider>();
    final cameraController = fileProvider.controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CustomLoader.loader()),
      );
    }
    final size = MediaQuery.of(context).size;
    final scale = size.aspectRatio * cameraController.value.aspectRatio;
    return WillPopScope(
      onWillPop: () async {
        if ( fileProvider.isVideo && fileProvider.isRecording) {
          await fileProvider.stopVideoRecording(save: false);
        }
        return true;
      },
      child: Scaffold(
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
                onTap: () async {
                  if (fileProvider.isVideo && fileProvider.isRecording) {
                    await fileProvider.stopVideoRecording(save: false);
                  }
                  if (!context.mounted) return;
                  context.pop();
                  },
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
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    if (fileProvider.isVideo) {
                      if (fileProvider.isRecording) {
                        await fileProvider.stopVideoRecording();
                        if (!context.mounted) return;
                        context.pop();
                      } else {
                        await fileProvider.startVideoRecording();
                      }
                    } else {
                      await fileProvider.takePicture(context);
                      if (!context.mounted) return;
                      context.pop();
                    }
                  },
                  child: fileProvider.isVideo ?
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2,
                        style: BorderStyle.solid,
                        color: whiteColor,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: CustomImage(image: fileProvider.isRecording ? stopIconImage : circleIconImage, scale: fileProvider.isRecording ? 18 : 10, color: Colors.red,),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     // shape: provider.isRecording ? BoxShape.rectangle : BoxShape.circle,
                      //     color: Colors.red,
                      //   ),
                      // ),
                    ),
                  ) :
                  CustomImage(image: cameraButtonIcon, scale: 4),
                ),
                // GestureDetector(
                //   onTap: () async {
                //     if(provider.isVideo){
                //       if(provider.isRecording){
                //         await provider.stopVideoRecording();
                //         if (!context.mounted) return;
                //         context.pop();
                //       }else{
                //         await provider.startVideoRecording();
                //       }
                //     }else{
                //       await provider.takePicture(context);
                //       if (!context.mounted) return;
                //       context.pop();
                //     }
                //     },
                //   child: provider.isVideo ?
                //   Container(
                //     height: 60,
                //     width: 60,
                //     decoration: BoxDecoration(
                //       color: provider.isRecording ? whiteColor : Colors.red,
                //       shape: BoxShape.circle,
                //       border: provider.isRecording ? null : Border.all(color: whiteColor, width: 5.0, style: BorderStyle.solid)
                //     ),
                //     child: provider.isRecording ?
                //        CustomImage(image: stopIconImage,scale: 22,color: Colors.red,) :
                //         null
                //   ) :
                //   CustomImage(image: cameraButtonIcon, scale: 4),
                // ),
              ),
            ),
            if (fileProvider.isVideo && fileProvider.isRecording)
              Positioned(
                top: MediaQuery.of(context).padding.top + 120,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: cameraBackConColor,
                      borderRadius: BorderRadius.circular(15.0)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedOpacity(
                              opacity: fileProvider.showBlink ? 1.0 : 0.2,
                              duration: Duration(microseconds: 100),
                              child: Icon(Icons.circle, color: Colors.red, size: 12)),
                          SizedBox(width: 6),
                          Text(
                            formatDuration(fileProvider.recordingSeconds),
                            style: TextStyle(
                              color: whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
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
    );
  }
}
