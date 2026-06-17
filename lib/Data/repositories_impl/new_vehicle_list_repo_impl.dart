import 'package:ats_app/Data/model/request_model/new_vehicle_list_req_model.dart';
import 'package:ats_app/Domain/entities/new_vehicle_list_entity.dart';
import 'package:ats_app/Domain/repositories/new_vehicle_list_repository.dart';

import '../../Core/network/api_services.dart';
import '../../Core/network/services.dart';
import '../model/response_model/new_vehicle_list_res_model.dart';

class NewVehicleListRepoImpl implements NewVehicleListRepository {

  @override
  Future<NewVehicleListEntity> newVehicleListApi(NewVehicleListReqModel requestModel) async {
    try{
      final response = await ApiService.post(requestModel, newVehicleListWithAppointmentUrl);
      final model = NewVehicleListResModel.fromJson(response);
      return NewVehicleListEntity(success: model.success, message: model.message, data: model.data, type: model.type, errors: model.errors);
    }catch (e){
      throw Exception(e);
    }
  }

}