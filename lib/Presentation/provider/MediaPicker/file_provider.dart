import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import '../../../main.dart';
import 'file_service.dart';

class FileProvider with ChangeNotifier {
  final FileService _fileService;

  FileProvider({FileService? fileService})
    : _fileService = fileService ?? FileService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  CameraController? controller;


  int? currentIndex;

  final List<XFile?> images = [];

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
  Future<void> takePicture(BuildContext context) async {

    _setLoading(true);
    try {
      final XFile picture = await controller!.takePicture();
      images[currentIndex!] = picture;
      debugPrint("taking picture : ${images[currentIndex!]!.name}");
      notifyListeners();
    } catch (e) {
      debugPrint("Error taking picture : $e");
    }
  }

  void removeImage(BuildContext context) {
    images.remove(currentIndex);
      notifyListeners();
  }

  void clearAll(BuildContext context){
    images.clear();
  }
}
