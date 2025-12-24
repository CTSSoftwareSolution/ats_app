import 'package:ats_app/Data/model/request_model/vehicle_parts_req_model.dart';
import 'package:ats_app/Domain/repositories/vehicle_parts_repository.dart';
import '../entities/vehicle_parts_entity.dart';

class VehiclePartsUseCases {
  VehiclePartsRepository vehiclePartsRepository;

  VehiclePartsUseCases({required this.vehiclePartsRepository});

  Future<VehiclePartsEntity> execute(VehiclePartsReqModel vehiclePartsReqModel){
    return vehiclePartsRepository.vehiclePartsApi(vehiclePartsReqModel);
  }
}