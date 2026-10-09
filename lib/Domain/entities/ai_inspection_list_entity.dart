import '../../Data/model/response_model/ai_inspection_list_res_model.dart';

class AiInspectionListEntity {
  bool? status;
      String? message;
  AiInspectionListData? data;

  AiInspectionListEntity({this.data, this.message, this.status});
}