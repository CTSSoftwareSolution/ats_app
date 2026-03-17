import 'package:flutter/src/widgets/framework.dart';

import 'aws_entity.dart';
import 'aws_request.dart';

abstract class AwsRepository {
  Future<AwsEntity> awsApi(AwsRequest request);
}
