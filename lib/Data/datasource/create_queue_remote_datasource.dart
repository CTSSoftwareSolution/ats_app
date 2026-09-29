import 'dart:convert';

import 'package:ats_app/Core/network/services.dart';

import '../../Core/network/api_services.dart';
import '../model/request_model/create_queue_req_model.dart';
import '../model/response_model/create_queue_res_model.dart';

abstract class CreateQueueRemoteDataSource {
  Future<CreateQueueResModel> createQueue(CreateQueueReqModel request);
}

class CreateQueueRemoteDataSourceImpl
    implements CreateQueueRemoteDataSource {

  final ApiService apiService;

  CreateQueueRemoteDataSourceImpl({
    required this.apiService,
  });



  @override
  Future<CreateQueueResModel> createQueue(
      CreateQueueReqModel request,
      ) async {
    final response = await apiService.postMultipart(
      apiUrl: createQueueUrl,
      fields: {
        'registration_no': request.registrationNo,
        'application_no': request.applicationNo,
        'question_id': request.questionId,
        'inspection_id': request.inspectionId,
      },
      imagePath: request.imagePath,
      videoPath: request.videoPath,
    );

    final Map<String, dynamic> json =
    jsonDecode(response.body) as Map<String, dynamic>;

    return CreateQueueResModel.fromJson(json);
  }
}