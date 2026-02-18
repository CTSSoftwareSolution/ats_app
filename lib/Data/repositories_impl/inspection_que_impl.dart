import 'package:ats_app/Data/model/response_model/inspection_que_model.dart';
import 'package:ats_app/Domain/entities/inspection_que_entity.dart';
import 'package:ats_app/Domain/repositories/inspection_que_repository.dart';

import '../../Core/network/api_services.dart';
import '../../Core/network/services.dart';


class InspectionQueImpl implements InspectionQueRepository{

  @override
  Future<InspectionQueEntity> questionApi() async{
    //final baseUrl = context.read<IpAddressProvider>().baseUrl;

    try{
      final response = await ApiService.post("", inspectionQueUrl);
      final model = InspectionModel.fromJson(response);
      return InspectionQueEntity(message: model.message, status: model.status, data: model.data);
    }catch (e){
      throw Exception(e);
    }
  }
}