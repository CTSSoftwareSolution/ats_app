import 'package:ats_app/Data/model/request_model/new_inspection_save_req_model.dart';
import 'package:ats_app/Domain/entities/new_inspection_save_entity.dart';

import '../../Core/network/api_services.dart';
import '../../Core/network/services.dart';
import '../../Domain/repositories/new_inspection_save_repository.dart';
import '../model/response_model/new_inspection_save_res_model.dart';

class NewInspectionSaveRepoImpl implements NewInspectionSaveRepository {

  @override
  Future<NewInspectionSaveEntity> newSaveApi({
    required String vehicleId,
    required String appointmentId,
    required String createdBy,
    required String questionId,
    required String result,
    required String severityLevel,
    required String observation,
    required List<NewInspectionSaveReqModel> saveInspectionReqModel,
  })async {
    try {

      final response = await ApiService.newSaveInspectionMultipartUpload(
        vehicleId: vehicleId,
        appointmentId: appointmentId,
        createdBy: createdBy,
        questionId: questionId,
        result: result,
        severityLevel: severityLevel,
        observation: observation,
        saveInspectionReqModel: saveInspectionReqModel,
        apiUrl: newSubmitItemUrl,
      );

      final model = NewInspectionSaveResModel.fromJson(response!);

      return NewInspectionSaveEntity(
        success: model.success,
        message: model.message,
        data: model.data,
        type: model.type,
        errors: model.errors,
      );

    } catch (e) {
      throw Exception(e);
    }
  }
}
