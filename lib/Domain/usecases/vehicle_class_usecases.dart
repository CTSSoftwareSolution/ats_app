import 'package:ats_app/Data/model/request_model/vehicle_class_req_model.dart';
import 'package:ats_app/Domain/entities/vehicle_class_entity.dart';
import 'package:ats_app/Domain/repositories/vehicle_class_repository.dart';


class VehicleClassUseCases {
  VehicleClassRepository vehicleClassRepository;

  VehicleClassUseCases({required this.vehicleClassRepository});

  Future<VehicleClassEntity> execute(VehicleClassReqModel vehicleClassReqModel){
    return vehicleClassRepository.vehicleClassApi(vehicleClassReqModel);
  }
}