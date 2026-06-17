import 'package:ats_app/Data/model/request_model/new_vehicle_list_req_model.dart';
import 'package:ats_app/Domain/entities/new_vehicle_list_entity.dart';

abstract class NewVehicleListRepository {
  Future<NewVehicleListEntity> newVehicleListApi(NewVehicleListReqModel requestModel);
}