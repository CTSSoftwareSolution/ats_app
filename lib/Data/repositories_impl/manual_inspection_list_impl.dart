
import 'package:ats_app/Data/model/request_model/manual_inspection_request.dart';
import 'package:ats_app/Data/model/response_model/manual_inspection_list_model.dart';
import 'package:ats_app/Domain/entities/manual_inspection_entity.dart';
import 'package:ats_app/Domain/repositories/manual_inspection_repository.dart';

import '../../Core/network/api_services.dart';
import '../../Core/network/services.dart';

class ManualInspectionListImpl implements ManualInspectionRepository{

  @override
  Future<ManualInspectionEntity> getManualInspectionRepository(ManualInspectionRequest request) async {
    try{
      final response = await ApiService.post(request, manualInspectionList);
      final model = ManualInspectionListModel.fromJson(response);
      return ManualInspectionEntity(message: model.message, data: model.data);
    }catch (e){
      throw Exception(e);
    }
  }
}