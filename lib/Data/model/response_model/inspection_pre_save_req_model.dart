import 'dart:io';

class InspectionPreSaveReqModel {
  final String questionId;
  final String inspectionResult;
  final String severityLevel;
  final String remarks;
  final File? image1;

  InspectionPreSaveReqModel({
    required this.questionId,
    required this.inspectionResult,
    required this.severityLevel,
    required this.remarks,
    this.image1,
  });
}