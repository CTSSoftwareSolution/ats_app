import 'package:ats_app/Domain/repositories/new_vehicle_list_repository.dart';

import '../../Data/model/request_model/new_vehicle_list_req_model.dart';
import '../entities/new_vehicle_list_entity.dart';

class NewVehicleListUseCases {
  NewVehicleListRepository newVehicleListRepository;

  NewVehicleListUseCases({required this.newVehicleListRepository});

  Future<NewVehicleListEntity> execute(NewVehicleListReqModel requestModel) {
    return newVehicleListRepository.newVehicleListApi(requestModel);
  }
}
