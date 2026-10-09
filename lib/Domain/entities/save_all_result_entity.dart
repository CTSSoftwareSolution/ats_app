import '../../Data/model/response_model/save_all_result_res_model.dart';

class SaveAllResultEntity {
  bool? success;
      String? message;
  SaveAiData? data;
      dynamic type;
  List<dynamic>? errors;

  SaveAllResultEntity({this.success, this.message, this.data, this.type, this.errors});
}