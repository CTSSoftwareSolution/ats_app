import 'dart:io';

class NewInspectionSaveReqModel {
  final String labelId;
  final String latitude;
  final String longitude;
  final File? file;

  NewInspectionSaveReqModel({
    required this.labelId,
    required this.latitude,
    required this.longitude,
    this.file,

  });
}