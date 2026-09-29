import 'package:ats_app/Domain/entities/create_queue_entity.dart';

import '../../Data/model/request_model/create_queue_req_model.dart';
import '../repositories/create_queue_repository.dart';

class CreateQueueUseCase {
  final CreateQueueRepository repository;

  CreateQueueUseCase({
    required this.repository,
  });

  Future<CreateQueueEntity> call(
      CreateQueueReqModel request,
      ) async {
    return await repository.createQueue(request);
  }
}