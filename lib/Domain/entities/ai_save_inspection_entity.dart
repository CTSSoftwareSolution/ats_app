import '../../Data/model/response_model/ai_save_inspection_res_model.dart';

class AiSaveInspectionEntity {
  bool? success;
  String? message;
  dynamic data;
  List<Errors>? errors;

  AiSaveInspectionEntity({this.success, this.message, this.data, this.errors});
}
