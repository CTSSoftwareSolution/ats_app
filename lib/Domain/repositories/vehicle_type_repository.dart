import 'package:ats_app/Domain/entities/vehicle_type_entity.dart';


abstract class VehicleTypeRepository {
  Future<VehicleTypeEntity> vehicleTypeApi();
}