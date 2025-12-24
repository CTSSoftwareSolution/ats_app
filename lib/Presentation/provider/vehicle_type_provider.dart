import 'package:ats_app/Domain/entities/vehicle_type_entity.dart';
import 'package:ats_app/Domain/usecases/vehicle_type_usecases.dart';
import 'package:flutter/cupertino.dart';

import '../../Data/model/response_model/vehicle_type_res_model.dart';
import '../../widgets/custom_loader.dart';

class VehicleTypeProvider extends ChangeNotifier{
  VehicleTypeUseCases vehicleTypeUseCases;

VehicleTypeProvider({required this.vehicleTypeUseCases});
VehicleTypeEntity? vehicleTypeEntity;
bool isLoading = true;

  TypeDataModel? typeDataModel;
  TypeDataModel? get selectedType => typeDataModel;
  void setSelectedType(TypeDataModel data){
    typeDataModel = data;
  }


  Future<VehicleTypeEntity?> vehicleTypeApi() async {
    isLoading = true;
    try {
      vehicleTypeEntity = await vehicleTypeUseCases.execute();
      return vehicleTypeEntity;
    } catch (e) {
      vehicleTypeEntity = null;
    } finally {
      CustomLoader.closeLoader();
      isLoading = false;
      notifyListeners();
    }
    return null;
  }
}