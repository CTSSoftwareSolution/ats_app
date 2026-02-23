import 'package:ats_app/Domain/entities/vehicle_type_entity.dart';
import 'package:ats_app/Domain/repositories/vehicle_type_repository.dart';

class VehicleTypeUseCases {
  VehicleTypeRepository vehicleTypeRepository;

  VehicleTypeUseCases({required this.vehicleTypeRepository});

  Future<VehicleTypeEntity> execute() {
    return vehicleTypeRepository.vehicleTypeApi();
  }
}
