import '../../Data/model/response_model/create_queue_res_model.dart';

class CreateQueueEntity {
  bool? success;
  String? message;
  QueueData? data;
  dynamic type;
  List<dynamic>? errors;

  CreateQueueEntity({this.success, this.message, this.data, this.errors});
}
