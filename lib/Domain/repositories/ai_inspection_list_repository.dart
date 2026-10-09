import 'package:ats_app/Data/model/request_model/ai_inspection_list_req_model.dart';
import 'package:ats_app/Domain/entities/ai_inspection_list_entity.dart';

abstract class AiInspectionListRepository {
  Future<AiInspectionListEntity> aiInspectedList(AiInspectionListReqModel requestModel);
}