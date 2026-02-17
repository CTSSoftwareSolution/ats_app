import 'package:ats_app/Core/network/services.dart';
import 'package:ats_app/Data/model/request_model/vehicle_parts_req_model.dart';
import 'package:ats_app/Domain/entities/vehicle_parts_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../Core/network/api_services.dart';
import '../../Domain/repositories/vehicle_parts_repository.dart';
import '../../Presentation/screens/ip_config/ip_address_provider.dart';
import '../model/response_model/vehicle_parts_res_model.dart';

class VehiclePartsRepoImpl implements VehiclePartsRepository{
  @override
  Future<VehiclePartsEntity> vehiclePartsApi(VehiclePartsReqModel vehiclePartsReqModel) async{
   // final baseUrl = context.read<IpAddressProvider>().baseUrl;
      try{
        final response = await ApiService.post(vehiclePartsReqModel, vehiclePartsUrl);
        final model = VehiclePartsResModel.fromJson(response);
        return VehiclePartsEntity(message: model.message, status: model.status, data: model.data);
      }catch (e){
        throw Exception(e);
      }
  }



}