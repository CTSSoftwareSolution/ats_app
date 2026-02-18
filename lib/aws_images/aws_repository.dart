



import 'aws_entity.dart';
import 'aws_request.dart';

abstract class AwsRepository {
  Future<AwsEntity> awsApi(AwsRequest request);
}
