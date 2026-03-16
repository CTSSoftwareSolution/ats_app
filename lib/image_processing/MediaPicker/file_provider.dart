import 'package:ats_app/image_processing/image_processing_service.dart';
import 'package:ats_app/widgets/custom_loader.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';
import '../../location/location_provider.dart';
import 'file_service.dart';

class FileProvider with ChangeNotifier {
  final FileService _fileService;

  final GlobalKey repaintKey = GlobalKey();

  FileProvider({FileService? fileService}) : _fileService = fileService ?? FileService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  XFile? originalImage;
  XFile? overlayImage;
  LocationProvider? locationProvider;

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

  void removeImage(BuildContext context) {
    images.remove(currentIndex);
      notifyListeners();
  }

  void clearAll(){
    images.clear();
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
      images[currentIndex!] = picture;
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

      overlayImage = XFile(overlayPath);
      if (currentIndex != null) {
        images[currentIndex!] = overlayImage;
      }

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

}
