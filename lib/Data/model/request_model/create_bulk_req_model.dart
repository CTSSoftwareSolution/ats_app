import 'dart:io';

class CreateBulkReqModel {
  final String questionId;
  final File? images;
  final File? videos;

  CreateBulkReqModel({
    required this.questionId,
    this.images,
    this.videos,
  });
}