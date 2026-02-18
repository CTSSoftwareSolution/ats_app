import 'package:ats_app/Core/network/services.dart';
import 'package:ats_app/Data/model/request_model/vehicle_class_req_model.dart';
import 'package:ats_app/Domain/entities/vehicle_class_entity.dart';
import 'package:ats_app/Domain/repositories/vehicle_class_repository.dart';


import '../../Core/network/api_services.dart';

import '../model/response_model/vehicle_class_res_model.dart';

class VehicleClassRepoImpl implements VehicleClassRepository{
  @override
  Future<VehicleClassEntity> vehicleClassApi(VehicleClassReqModel vehicleClassReqModel) async {
    //final baseUrl = context.read<IpAddressProvider>().baseUrl;
    try{
      final response = await ApiService.post(vehicleClassReqModel, vehicleClassUrl);
      final model = VehicleClassResModel.fromJson(response);
      return VehicleClassEntity(message: model.message, status: model.status, data: model.data);
    }catch (e){
      throw Exception(e);
    }
  }

}