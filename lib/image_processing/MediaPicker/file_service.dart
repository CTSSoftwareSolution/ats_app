import 'dart:io';
import 'package:image_picker/image_picker.dart';



class FileService {
  final ImagePicker _imagePicker = ImagePicker();

  /// Capture single photo from camera_page (returns path or null)
  Future<String?> pickImageFromCamera({int imageQuality = 85}) async {
    final XFile? picked = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: imageQuality,
    );
    return picked?.path;
  }

  /// Pick single image from gallery (returns File or null)
  Future<File?> pickSingleImage({int imageQuality = 85}) async {
    final XFile? picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality,
    );
    return picked != null ? File(picked.path) : null;
  }

}
