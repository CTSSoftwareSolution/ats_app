import 'package:ats_app/Domain/entities/create_queue_entity.dart';

import '../../Data/model/request_model/create_queue_req_model.dart';


abstract class CreateQueueRepository {
  Future<CreateQueueEntity> createQueue(
      CreateQueueReqModel request,
      );
}