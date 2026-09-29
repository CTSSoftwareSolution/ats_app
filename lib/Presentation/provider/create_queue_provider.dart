import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Domain/entities/create_queue_entity.dart';
import '../../Data/model/request_model/create_queue_req_model.dart';
import '../../Domain/repositories/create_queue_repository.dart';

class CreateQueueProvider extends ChangeNotifier {
  final CreateQueueRepository repository;

  CreateQueueProvider({
    required this.repository,
  });

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  CreateQueueEntity? _queueResponse;
  CreateQueueEntity? get queueResponse => _queueResponse;

  /// Successfully uploaded image paths, keyed per application + question so
  /// an image is never reused for another question or another vehicle.
  /// Persisted in SharedPreferences so it survives app restarts.
  final Map<String, String> _uploadedImages = {};
  bool _uploadedImagesLoaded = false;
  static const String _uploadedImagesPrefKey = 'uploadedQueueImages';

  String _imageKey(String applicationNo, String questionId) =>
      '$applicationNo|$questionId';

  Future<void> _loadUploadedImages() async {
    if (_uploadedImagesLoaded) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_uploadedImagesPrefKey);
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        _uploadedImages.addAll(decoded.map((k, v) => MapEntry(k, v.toString())));
      }
      debugPrint('[MEDIA] Loaded ${_uploadedImages.length} stored image path(s)');
    } catch (e) {
      debugPrint('[MEDIA] Failed to load stored image paths: $e');
    }
    _uploadedImagesLoaded = true;
  }

  /// Call on logout so stored image paths don't carry over to the next session.
  Future<void> clearUploadedImages() async {
    _uploadedImages.clear();
    _uploadedImagesLoaded = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_uploadedImagesPrefKey);
    } catch (e) {
      debugPrint('[MEDIA] Failed to clear stored image paths: $e');
    }
    debugPrint('[MEDIA] Cleared stored image paths');
  }

  Future<void> _saveUploadedImages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_uploadedImagesPrefKey, jsonEncode(_uploadedImages));
    } catch (e) {
      debugPrint('[MEDIA] Failed to persist stored image paths: $e');
    }
  }

  Future<CreateQueueEntity?> uploadMedia({
    required String registrationNo,
    required String applicationNo,
    required String questionId,
    required String inspectionId,
    String? imagePath,
    String? videoPath,
  }) async {
    try {
      _isUploading = true;
      _errorMessage = null;
      _queueResponse = null;
      notifyListeners();

      await _loadUploadedImages();
      final key = _imageKey(applicationNo, questionId);

      // Video upload: attach this question's previously uploaded image, if any.
      if (videoPath != null && imagePath == null) {
        final storedImage = _uploadedImages[key];
        if (storedImage != null && File(storedImage).existsSync()) {
          imagePath = storedImage;
          debugPrint('[MEDIA] Attaching stored image for questionId $questionId: $storedImage');
        } else {
          debugPrint('[MEDIA] No stored image for questionId $questionId, sending video only');
        }
      }

      debugPrint('[MEDIA] Queue request -> questionId: $questionId, '
          'inspectionId: $inspectionId, imagePath: $imagePath, videoPath: $videoPath');

      final request = CreateQueueReqModel(
        registrationNo: registrationNo,
        applicationNo: applicationNo,
        questionId: questionId,
        inspectionId: inspectionId,
        imagePath: imagePath,
        videoPath: videoPath,
      );

      final result = await repository.createQueue(request);

      debugPrint("QueueResult: ${result.toString()}");

      _queueResponse = result;

      if (result.success != true) {
        _errorMessage = result.message;
      } else if (imagePath != null) {
        _uploadedImages[key] = imagePath;
        await _saveUploadedImages();
        debugPrint('[MEDIA] Stored image for questionId $questionId: $imagePath');
      }

      return result;
    } catch (e) {
      _errorMessage = e.toString();

      debugPrint('Queue upload error: $e');

      return null;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
}