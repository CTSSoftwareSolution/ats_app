import 'package:flutter/cupertino.dart';

import '../Core/network/api_services.dart';
import '../Core/network/services.dart';
import 'aws_entity.dart';
import 'aws_model.dart';
import 'aws_repository.dart';
import 'aws_request.dart';

class AwsRepositoryImpl implements AwsRepository {


  @override
  Future<AwsEntity> awsApi(AwsRequest request) async {
    try {
      final response = await ApiService.post(request.toJson(), awsSignedUrl);
      final model = AwsModel.fromJson(response);
      return AwsEntity(status: model.status, url: model.url);
    } catch (e) {
      throw Exception(e);
    }
  }
}
