class CreateQueueReqModel {
  final String registrationNo;
  final String applicationNo;
  final String questionId;
  final String inspectionId;
  final String? imagePath;
  final String? videoPath;

  const CreateQueueReqModel({
    required this.registrationNo,
    required this.applicationNo,
    required this.questionId,
    required this.inspectionId,
    this.imagePath,
    this.videoPath,
  });
}