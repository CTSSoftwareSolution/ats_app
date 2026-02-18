


import 'aws_entity.dart';
import 'aws_repository.dart';
import 'aws_request.dart';

class AwsUseCase {
   AwsRepository repository;
  AwsUseCase({required this.repository});

  Future<AwsEntity> execute(AwsRequest request) {
    return repository.awsApi(request);
  }
}
