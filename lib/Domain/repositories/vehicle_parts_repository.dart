import 'package:ats_app/Data/model/request_model/vehicle_parts_req_model.dart';
import 'package:ats_app/Domain/entities/vehicle_parts_entity.dart';

abstract class VehiclePartsRepository {
  Future<VehiclePartsEntity> vehiclePartsApi(VehiclePartsReqModel vehiclePartsReqModel);
}