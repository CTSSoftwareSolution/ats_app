import 'package:ats_app/Domain/entities/lane_list_entity.dart';
import 'package:ats_app/Domain/repositories/lane_list_repository.dart';

class LaneListUseCase {
  LaneListRepository laneListRepository;

  LaneListUseCase({required this.laneListRepository});

  Future<LaneListEntity> execute() {
    return laneListRepository.laneListApi();
  }
}
