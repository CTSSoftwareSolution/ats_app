import 'package:ats_app/Core/network/api_services.dart';
import 'package:ats_app/Data/model/request_model/create_bulk_req_model.dart';
import 'package:ats_app/Data/model/response_model/create_bulk_res_model.dart';
import 'package:ats_app/Domain/entities/create_bulk_entity.dart';
import 'package:ats_app/Domain/repositories/create_bulk_repository.dart';

import '../../Core/network/services.dart';

class CreateBulkRepoImpl implements CreateBulkRepository{

  @override
  Future<CreateBulkEntity> aiMediaUpload({
    required String registrationNumber,
    required String applicationNumber,
    required String appointmentId,
    required String createdBy,
    required List<CreateBulkReqModel> questions,
}) async {

    try{

      final response = await ApiService.aiMultipartUpload(
          registrationNumber: registrationNumber,
          applicationNumber: applicationNumber,
          appointmentId: appointmentId,
          createdBy: createdBy,
          mediaType: questions,
          apiUrl: createBulkUrl
      );

      final model = CreateBulkResModel.fromJson(response);

      return CreateBulkEntity(
        success: model.success,
        message: model.message,
        data: model.data,
        errors: model.errors
      );

    }catch (e){
      throw Exception(e);
    }

}
}