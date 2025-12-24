import 'package:ats_app/Data/model/request_model/vehicle_class_req_model.dart';
import 'package:ats_app/Domain/entities/vehicle_class_entity.dart';

abstract class VehicleClassRepository {
  Future<VehicleClassEntity> vehicleClassApi(VehicleClassReqModel vehicleClassReqModel);
}