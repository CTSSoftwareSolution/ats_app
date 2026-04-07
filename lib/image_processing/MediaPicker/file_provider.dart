import 'dart:async';
import 'dart:io';

import 'package:ats_app/image_processing/image_processing_service.dart';
import 'package:ats_app/widgets/custom_loader.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';
import '../../location/location_provider.dart';
import 'file_service.dart';

class MediaFile {
   XFile? image;
   XFile? video;
   bool? isVideo;

  MediaFile({ this.image,  this.video,  this.isVideo});
}

class FileProvider with ChangeNotifier {
  final FileService _fileService;

  final GlobalKey repaintKey = GlobalKey();

  FileProvider({FileService? fileService}) : _fileService = fileService ?? FileService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  XFile? originalImage;
  XFile? originalVideo;
  XFile? overlayImage;
  XFile? overlayVideo;
  LocationProvider? locationProvider;

  CameraController? controller;
  int? currentIndex;
  final List<XFile?> images = [];
  final List<XFile?> videos = [];

final List<MediaFile?> mediaFile = [];

   bool _isVideo = false;
  bool get isVideo => _isVideo;

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  Timer? timer;
  int _recordingSeconds = 0;
  int get recordingSeconds => _recordingSeconds;

  bool _showBlink = true;
  bool get showBlink => _showBlink;

  DeviceOrientation? _currentOrientation = DeviceOrientation.portraitUp;
  DeviceOrientation? get currentOrientation => _currentOrientation;

  void timerStart(){
    _recordingSeconds = 0;
    _showBlink = true;
    timer = Timer.periodic(Duration(seconds: 1), (_){
      _recordingSeconds++;
      _showBlink = !_showBlink;
      notifyListeners();
    });
  }

  void timerStop(){
    timer?.cancel();
    timer = null;
    _recordingSeconds = 0;
    _showBlink = true;
    notifyListeners();
  }


  void setVideo(bool v){
    _isVideo = v;
    notifyListeners();
  }
 //  String? fileImagePath;

  void setCurrentIndex(int value){
    currentIndex = value;

    while (mediaFile.length <= currentIndex!){
      mediaFile.add(MediaFile());
    }
    //
    // while (images.length <= currentIndex!) {
    //   images.add(null);
    // }
    //
    // while (videos.length <= currentIndex!) {
    //   videos.add(null);
    // }
  }


  XFile? get getOverlayImage {
    if (currentIndex != null && currentIndex! < images.length) {
      return images[currentIndex!];
    }
    return null;
  }

  XFile? getImage(int index) {
    if (index < images.length) {
      return images[index];
    }
    return null;
  }

  MediaFile? getMedia(int index) {
    if (index < mediaFile.length) {
      return mediaFile[index];
    }
    return null;
  }


  List<XFile?> get allImages => images;
  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  Future<void> initCamera() async {
    if (controller != null){
      if(controller!.value.isInitialized) return;
      await controller!.initialize();

      /// LISTEN for orientation updates
      controller!.addListener(() {
        final newOrientation = controller!.value.deviceOrientation;

        if (_currentOrientation != newOrientation) {
          _currentOrientation = newOrientation;
          debugPrint("Updated Orientation: $_currentOrientation");
        }
      });

      notifyListeners();
      return;
    }
    controller = CameraController(
      cameras![0],
      ResolutionPreset.high,
      enableAudio: false,
    );



    if(isRecording){
      stopVideoRecording();
    }

      await controller!.initialize();
      notifyListeners();
  }

  /// Pick single image from gallery and store as File
  Future<void> pickSingleImage(BuildContext context) async {
    _setLoading(true);
    try {
      final file = await _fileService.pickSingleImage();
      if (file != null) {
        images[currentIndex!] = XFile(file.path);
        debugPrint("Selected image from gallery ${images[currentIndex!]!.name}");
      }
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  /// In-app camera_page
  // Future<void> takePicture(BuildContext context) async {
  //  // takePictureWithRender(context);
  //     _setLoading(true);
  //     try {
  //       final XFile picture = await controller!.takePicture();
  //       images[currentIndex!] = picture;
  //       debugPrint("taking picture : ${images[currentIndex!]!.name}");
  //       final imagePath = picture.path.split(Platform.pathSeparator).last;
  //       notifyListeners();
  //     } catch (e) {
  //       debugPrint("Error taking picture : $e");
  //     }
  // }

  void removeImage(BuildContext context) {
    images.remove(currentIndex);
      notifyListeners();
  }

  void clearAll(){
    images.clear();
    videos.clear();
    mediaFile.clear();
    currentIndex = null;
    notifyListeners();
  }

  void clearImages() {
    for (int i = 0; i < images.length; i++) {
      images[i] = null;
    }
    currentIndex = null;
    notifyListeners();
  }

  // Future<void> takePicture(BuildContext context) async {
  //   //_setLoading(true);
  //   HapticFeedback.heavyImpact();
  //   CustomLoader.showLoader("Image Processing...");
  //   try {
  //     if (controller == null || !controller!.value.isInitialized) {
  //       throw Exception("Camera not initialized");
  //     }
  //     final XFile picture = await controller!.takePicture();
  //     // Original Image
  //     originalImage = picture;
  //     final file = File(picture.path);
  //     final overlayData = {
  //       'vehicleNo': 'MH20DC1761',
  //       'address': 'Navi Mumbai',
  //       'lat': 23.45,
  //       'lng': 72.11,
  //       'date': DateTime.now().toString(),
  //     };
  //     final overlayText = jsonEncode(overlayData);
  //     final displayText = "Vehicle No: MH20DC1761\nAddress: Navi Mumbai\nLat: 23.45, Lng: 72.11\nDate: ${DateTime.now()}";
  //     final bytes = await file.readAsBytes();
  //     final src = img.decodeImage(bytes)!;
  //     img.drawString(src, displayText, font: img.arial24, x: 16, y: src.height - 120, color: img.ColorRgba8(255, 255, 255, 255));
  //     final overlayFile = File(picture.path.replaceFirst('.jpg', '_overlay.jpg'));
  //     await overlayFile.writeAsBytes(img.encodeJpg(src, quality: 92));
  //     // Meta Data
  //     final exif = await Exif.fromPath(overlayFile.path);
  //     await exif.writeAttributes({
  //       'GPSLatitude': '23.45',
  //       'GPSLongitude': '72.11',
  //       'UserComment': overlayText,
  //       'ImageDescription': overlayText,
  //     });
  //     await exif.close();
  //     overlayImage = XFile(overlayFile.path);
  //     if (currentIndex != null) {
  //       images[currentIndex!] = overlayImage;
  //     }
  //     HapticFeedback.heavyImpact();
  //     CustomLoader.closeLoader();
  //     if (kDebugMode) {
  //       final result = await SaverGallery.saveFile(
  //         filePath: overlayImage!.path,
  //         androidRelativePath: 'Pictures/MyApp Images',
  //         fileName: picture.name,
  //         skipIfExists: false,
  //       );
  //       if (result.isSuccess) {
  //         CustomLoader.message('Saved Image in gallery');
  //       } else {
  //         CustomLoader.message('Not saved: ${result.errorMessage}');
  //       }
  //     }
  //     notifyListeners();
  //   } catch (e) {
  //     debugPrint("Error taking picture : $e");
  //   } finally {
  //     _setLoading(false);
  //   }
  // }

  Future<void> takePicture(BuildContext context) async {
    final location = Provider.of<LocationProvider>(context, listen: false);
    HapticFeedback.heavyImpact();
    CustomLoader.showLoader("Image Processing...");
    try {
      if (controller == null || !controller!.value.isInitialized) {
        throw Exception("Camera not initialized");
      }
      final XFile picture = await controller!.takePicture();
      originalImage = picture;

      // if (currentIndex != null && currentIndex! < images.length) {
      //   images[currentIndex!] = picture;
      // }
      final overlayPath = await ImageProcessingService.processOverlayImage(picture: picture,context: context);
      final lat = location.currentPosition?.latitude ?? 0.0;
      final lng = location.currentPosition?.longitude ?? 0.0;

      await ImageProcessingService.writeExifMetadata(
        overlayPath,
        lat: lat,
        lng: lng,
        overlayData: {
          'vehicleNo': 'MH20DC1761',
          'address': 'Navi Mumbai',
          'lat': lat,
          'lng': lng,
          'date': DateTime.now().toString(),
        },
      );

      await ImageProcessingService.saveToGallery(overlayPath, picture.name);



      final processedFile = XFile(overlayPath);
      overlayImage = processedFile;

      if(currentIndex != null && currentIndex! < mediaFile.length){
        mediaFile[currentIndex!]?.image = processedFile;
      }

      // if (currentIndex != null && currentIndex! < images.length) {
      //   images[currentIndex!] = overlayImage;
      // }



      HapticFeedback.heavyImpact();
      CustomLoader.closeLoader();
      notifyListeners();
    } catch (e) {
      debugPrint("Error taking picture: $e");
      CustomLoader.closeLoader();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> startVideoRecording(BuildContext context)async {
    try{

      if (controller == null || !controller!.value.isInitialized) {
        throw Exception("Camera not initialized");
      }

      final orientation = _currentOrientation;
      await controller!.lockCaptureOrientation(orientation);
      if (orientation == DeviceOrientation.portraitUp ||
          orientation == DeviceOrientation.portraitDown) {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      } else {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
      await controller!.startVideoRecording();



       debugPrint("Camera Orientation: $orientation");
      _isRecording = true;
      timerStart();

    }catch (e){
      debugPrint("Video error: $e");
      CustomLoader.closeLoader();
    }
  }

  Future<void> stopVideoRecording({bool save = true})async {
    try{

      if (controller == null || !controller!.value.isRecordingVideo)return;

      final XFile video = await controller!.stopVideoRecording();
      _isRecording = false;
      timerStop();

      if(save) {
        originalVideo = video;

        // if (currentIndex != null && currentIndex! < videos.length) {
        //         videos[currentIndex!] = video;
        //       }

        final processedVideo = XFile(video.path);
        overlayVideo = processedVideo;

        if (currentIndex != null && currentIndex! < mediaFile.length) {
          mediaFile[currentIndex!]?.video = processedVideo;
        }

        debugPrint("Video saved: ${video.path}");
        notifyListeners();
      }else{
        debugPrint("Video discarded");
      }
      await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      await controller!.unlockCaptureOrientation();

    }catch (e){
      debugPrint("Video error: $e");
      CustomLoader.closeLoader();
    }
  }

  // Future<void> recordVideo() async {
  //   CustomLoader.showLoader("Video processing...");
  //   try {
  //     if (controller == null || !controller!.value.isInitialized) {
  //       throw Exception("Camera not initialized");
  //     }
  //
  //      await controller!.startVideoRecording();
  //
  //
  //     await Future.delayed(Duration(seconds: 5));
  //
  //     final XFile video = await controller!.stopVideoRecording();
  //     originalVideo = video;
  //
  //
  //     if (currentIndex != null && currentIndex! < videos.length) {
  //       videos[currentIndex!] = video;
  //     }
  //     debugPrint("OriginalVideo Path: ${originalVideo!.path.toString()}");
  //
  //     overlayVideo =  XFile(video.path);
  //
  //     if (currentIndex != null && currentIndex! < videos.length) {
  //       videos[currentIndex!] = overlayVideo;
  //     }
  //
  //     debugPrint("OriginalVideo Path: ${overlayVideo?.path.toString()}");
  //     CustomLoader.closeLoader();
  //     notifyListeners();
  //
  //   } catch (e) {
  //     debugPrint("Video error: $e");
  //     CustomLoader.closeLoader();
  //   } finally {
  //     _setLoading(false);
  //   }
  // }


  Future<void> disposeCamera() async {
    try {
      if (controller != null) {
        if (controller!.value.isRecordingVideo) {
          await controller!.stopVideoRecording();
        }

        if (controller!.value.isStreamingImages) {
          await controller!.stopImageStream();
        }

        await controller!.dispose();
        controller = null;
      }
    } catch (e) {
      debugPrint("Dispose error: $e");
    }
  }

  void clearOverlayImage() {
    overlayImage = null;
    notifyListeners();
  }

}
