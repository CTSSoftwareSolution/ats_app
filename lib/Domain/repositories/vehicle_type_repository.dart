import 'package:ats_app/Domain/entities/vehicle_type_entity.dart';
import 'package:flutter/cupertino.dart';

abstract class VehicleTypeRepository {
  Future<VehicleTypeEntity> vehicleTypeApi();
}