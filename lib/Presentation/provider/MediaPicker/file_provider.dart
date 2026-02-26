import 'dart:io';
import 'package:ats_app/widgets/custom_loader.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:image/image.dart' as img;
import '../../../main.dart';
import 'file_service.dart';

class FileProvider with ChangeNotifier {
  final FileService _fileService;

  final GlobalKey repaintKey = GlobalKey();

  FileProvider({FileService? fileService}) : _fileService = fileService ?? FileService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  CameraController? controller;
  int? currentIndex;
  final List<XFile?> images = [];
 //  String? fileImagePath;

  void setCurrentIndex(int value){
    currentIndex = value;
    while (images.length <= currentIndex!) {
      images.add(null);
    }
  }

  XFile? getImage(int index) {
    if (index < images.length) {
      return images[index];
    }
    return null;
  }


  List<XFile?> get allImages => images;
  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  Future<void> initCamera() async {
    if (controller != null && controller!.value.isInitialized) return;
    controller = CameraController(
      cameras![0],
      ResolutionPreset.high,
      enableAudio: false,
    );
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

  // Future<void> takePictureWithRender(BuildContext context) async {
  //   _setLoading(true);
  //
  //   try {
  //     if (controller == null || !controller!.value.isInitialized) {
  //       throw Exception("Camera not initialized");
  //     }
  //
  //     final XFile picture = await controller!.takePicture();
  //     debugPrint("taking picture : ${picture.name}");
  //     final file = File(picture.path);
  //     notifyListeners();
  //     await Future.delayed(const Duration(milliseconds: 200));
  //     final boundary = repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  //     if (boundary == null) {
  //       _setLoading(false);
  //       return;
  //     }
  //     ui.Image image = await boundary.toImage(pixelRatio: 3);
  //     ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //     if (byteData == null) {
  //       _setLoading(false);
  //       return;
  //     }
  //     Uint8List pngBytes = byteData.buffer.asUint8List();
  //     final directory = file.parent.path;
  //     final fileName = 'overlay_${DateTime.now().millisecondsSinceEpoch}.png';
  //     final overlayFilePath = '$directory/$fileName';
  //     final overlayFile = await File(overlayFilePath).writeAsBytes(pngBytes);
  //     if (currentIndex != null) {
  //       images[currentIndex!] = XFile(overlayFile.path);
  //     }
  //     debugPrint("Overlay file path : ${overlayFile.path}");
  //   } catch (e) {
  //     if (context.mounted) {
  //       context.showErrorSnackBar("Could not capture image: $e");
  //     }
  //   }
  //   _setLoading(false);
  // }

  void removeImage(BuildContext context) {
    images.remove(currentIndex);
      notifyListeners();
  }

  void clearAll(BuildContext context){
    images.clear();
  }


  XFile? originalImage;
  XFile? overlayImage;

  Future<void> takePicture(BuildContext context) async {
    _setLoading(true);
    try {
      if (controller == null || !controller!.value.isInitialized) {
        throw Exception("Camera not initialized");
      }
      final XFile picture = await controller!.takePicture();
      //Original Image
      originalImage = picture;
      final file = File(picture.path);
      //Overlay Image
      final overlayText = "Vehicle No: MH20DC1761\nAddress: Navi Mumbai\nLat: 23.45, Lng: 72.11\nDate: ${DateTime.now()}";
      final bytes = await file.readAsBytes();
      final src = img.decodeImage(bytes)!;
      img.drawString(src, overlayText, font: img.arial24, x: 16, y: src.height - 120, color: img.ColorRgba8(255, 255, 255, 255));
      final overlayFile = File(picture.path.replaceFirst('.jpg', '_overlay.jpg'));
      await overlayFile.writeAsBytes(img.encodeJpg(src, quality: 92));
      overlayImage = XFile(overlayFile.path);
      if (currentIndex != null) {
        images[currentIndex!] = overlayImage;
      }
      if(kDebugMode){
        final result = await SaverGallery.saveFile(
          filePath: overlayImage!.path,
          androidRelativePath: 'Pictures/MyApp Images',
          fileName: picture.name,
          skipIfExists: false,
        );
        if (result.isSuccess) {
          CustomLoader.message('Saved Image in gallery');
        } else {
          CustomLoader.message('Not saved: ${result.errorMessage}');
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error taking picture : $e");
    } finally {
      _setLoading(false);
    }
  }




}
