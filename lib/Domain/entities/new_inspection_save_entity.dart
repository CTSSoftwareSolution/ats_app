import '../../Data/model/response_model/new_inspection_save_res_model.dart';

class NewInspectionSaveEntity {

  bool? success;
  String? message;
  NewSaveDataModel? data;
  dynamic type;
  List<dynamic>? errors;

  NewInspectionSaveEntity({
    this.success,
    this.message,
    this.data,
    this.type,
    this.errors,
  });

}