import 'package:ats_app/Data/model/response_model/ai_save_inspection_res_model.dart';
import 'package:ats_app/Domain/repositories/ai_save_inspection_repository.dart';

import '../../Core/network/api_services.dart';
import '../../Core/network/services.dart';
import '../../Domain/entities/ai_save_inspection_entity.dart';
import '../../Domain/entities/pre_save_inspection_entity.dart';
import '../../Domain/repositories/pre_save_inspection_repository.dart';
import '../model/response_model/inspection_pre_save_req_model.dart';
import '../model/response_model/inspection_pre_save_res_model.dart';


class AiSaveInspectionRepoImpl implements AISaveInspectionRepository {

  @override
  Future<AiSaveInspectionEntity> aiSaveInspection({
    required String appointmentId,
    required String inspectedBy,
    required String vehicleId,
    required List<InspectionPreSaveReqModel> inspections,

  }) async {

    try {

      final response = await ApiService.aiSaveInspectionMultipartUpload(
        appointmentId: appointmentId,
        inspectedBy: inspectedBy,
        vehicleId: vehicleId,
        inspections: inspections,
        apiUrl: aiSavePreInspection,
      );

      final model = AiSaveInspectionResModel.fromJson(response!);

      return AiSaveInspectionEntity(
        success: model.success,
        message: model.message,
        data: model.data,
        errors: model.errors
      );

    } catch (e) {
      throw Exception(e);
    }

  }



}

