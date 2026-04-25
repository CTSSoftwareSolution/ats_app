import 'package:ats_app/Domain/entities/create_bulk_entity.dart';

import '../../Data/model/request_model/create_bulk_req_model.dart';

abstract class CreateBulkRepository {
  Future<CreateBulkEntity> aiMediaUpload({
    required String registrationNumber,
    required String applicationNumber,
    required String createdBy,
    required String appointmentId,
    required List<CreateBulkReqModel> questions,
  });
}