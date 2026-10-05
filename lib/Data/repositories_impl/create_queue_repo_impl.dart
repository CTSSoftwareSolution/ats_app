import '../../Domain/entities/create_queue_entity.dart';
import '../../Domain/repositories/create_queue_repository.dart';
import '../datasource/create_queue_remote_datasource.dart';
import '../model/request_model/create_queue_req_model.dart';


class CreateQueueRepositoryImpl implements CreateQueueRepository {
  final CreateQueueRemoteDataSource remoteDataSource;

  CreateQueueRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<CreateQueueEntity> createQueue(
      CreateQueueReqModel request,
      ) async {
    return await remoteDataSource.createQueue(request);
  }
}