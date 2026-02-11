import 'package:ats_app/Data/model/request_model/login_req_model.dart';
import 'package:ats_app/Data/model/request_model/pre_inspection_result_req_model.dart';
import 'package:ats_app/Data/model/response_model/inspection_que_model.dart';
import 'package:ats_app/Data/model/response_model/pre_inspection_result_model.dart';
import 'package:ats_app/Domain/entities/inspection_que_entity.dart';
import 'package:ats_app/Domain/entities/login_entity.dart';
import 'package:ats_app/Domain/entities/pre_inspection_result_entity.dart';
import 'package:ats_app/Domain/repositories/inspection_que_repository.dart';
import 'package:ats_app/Domain/repositories/login_repository.dart';
import 'package:ats_app/Domain/repositories/pre_inspection_result_repository.dart';
import 'package:ats_app/utilities/preferences.dart';
import '../../Core/network/api_services.dart';
import '../../Core/network/services.dart';
import '../model/response_model/login_res_model.dart';

class PreInspectionResultImpl implements PreInspectionResultRepository{

  @override
  Future<PreInspectionResultEntity> saveResult(PreInspectionResultReqModel resultReqModel) async{
    try{
      final response = await ApiService.post(resultReqModel, savePreInspectionResultsUrl);
      final model = PreInspectionResultModel.fromJson(response);
      return PreInspectionResultEntity(message: model.message, status: model.status, data: model.data);
    }catch (e){
      throw Exception(e);
    }
  }
}