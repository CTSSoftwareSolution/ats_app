import 'package:ats_app/Data/model/request_model/login_req_model.dart';
import 'package:ats_app/Data/model/response_model/inspection_que_model.dart';
import 'package:ats_app/Domain/entities/inspection_que_entity.dart';
import 'package:ats_app/Domain/entities/login_entity.dart';
import 'package:ats_app/Domain/repositories/inspection_que_repository.dart';
import 'package:ats_app/Domain/repositories/login_repository.dart';
import 'package:ats_app/utilities/preferences.dart';
import '../../Core/network/api_services.dart';
import '../../Core/network/services.dart';
import '../model/response_model/login_res_model.dart';

class InspectionQueImpl implements InspectionQueRepository{

  @override
  Future<InspectionQueEntity> questionApi() async{
    try{
      final response = await ApiService.post("", inspectionQueUrl);
      final model = InspectionQueModel.fromJson(response);
      return InspectionQueEntity(message: model.message, status: model.status, data: model.data);
    }catch (e){
      throw Exception(e);
    }
  }
}