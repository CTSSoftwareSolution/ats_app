import 'package:ats_app/Data/model/request_model/login_req_model.dart';
import 'package:ats_app/Data/model/response_model/inspection_que_model.dart';
import 'package:ats_app/Data/model/response_model/inspection_type_res_model.dart';
import 'package:ats_app/Domain/entities/inspection_que_entity.dart';
import 'package:ats_app/Domain/entities/inspection_type_entity.dart';
import 'package:ats_app/Domain/entities/login_entity.dart';
import 'package:ats_app/Domain/repositories/inspection_que_repository.dart';
import 'package:ats_app/Domain/repositories/inspection_type_repository.dart';
import 'package:ats_app/Domain/repositories/login_repository.dart';
import 'package:ats_app/utilities/preferences.dart';
import '../../Core/network/api_services.dart';
import '../../Core/network/services.dart';
import '../model/response_model/login_res_model.dart';

class InspectionTypeImpl implements InspectionTypeRepository{

  @override
  Future<InspectionTypeEntity> getInspectionType() async{
    try{
      final response = await ApiService.post("", getInspectionTypeUrl);
      final model = InspectionTypeResModel.fromJson(response);
      return InspectionTypeEntity(message: model.message, status: model.status, data: model.data);
    }catch (e){
      throw Exception(e);
    }
  }


}