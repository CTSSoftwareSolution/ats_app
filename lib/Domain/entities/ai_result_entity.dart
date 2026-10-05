import '../../Data/model/response_model/ai_result_response.dart';

class AiResultEntity {
  bool? success;
  String? message;
  List<ResultData>? data;
  dynamic type;
  List<dynamic>? errors;

  AiResultEntity({ this.success,  this.data,  this.message,
     this.errors,  this.type});
}