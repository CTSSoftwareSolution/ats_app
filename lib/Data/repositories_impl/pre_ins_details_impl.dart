import 'package:ats_app/Core/network/services.dart';
import 'package:ats_app/Data/model/request_model/pre_ins_details_req_model.dart';
import 'package:ats_app/Domain/entities/pre_ins_details_entity.dart';
import 'package:ats_app/Domain/repositories/pre_ins_details_repository.dart';
import '../../Core/network/api_services.dart';
import '../model/response_model/pre_ins_details_res_model.dart';

class PreInsDetailsImpl implements PreInsDetailsRepository{

  @override
  Future<PreInsDetailsEntity> preInspectionDetails(PreInsDetailsReqModel preInsDetailsReqModel) async{
    try{
      final response = await ApiService.post(preInsDetailsReqModel, getPreInspectionDetailsUrl);
      final model = PreInsDetailsResModel.fromJson(response);
      return PreInsDetailsEntity(message: model.message, status: model.status, data: model.data);
    }catch (e){
      throw Exception(e);
    }
  }
}