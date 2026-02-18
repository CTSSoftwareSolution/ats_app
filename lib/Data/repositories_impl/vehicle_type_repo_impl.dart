import 'package:ats_app/Core/network/services.dart';
import 'package:ats_app/Data/model/response_model/vehicle_type_res_model.dart';
import 'package:ats_app/Domain/entities/vehicle_type_entity.dart';
import 'package:ats_app/Domain/repositories/vehicle_type_repository.dart';
import '../../Core/network/api_services.dart';


class VehicleTypeRepoImpl implements VehicleTypeRepository{
  @override
  Future<VehicleTypeEntity> vehicleTypeApi() async {
   // final baseUrl = context.read<IpAddressProvider>().baseUrl;
    try{
      final response = await ApiService.post("", vehicleTypeUrl);
      final model = VehicleTypeResModel.fromJson(response);
      return VehicleTypeEntity(message: model.message, status: model.status, data: model.data);
    }catch (e){
      throw Exception(e);
    }
  }


}