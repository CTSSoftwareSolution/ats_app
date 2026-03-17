
import 'package:flutter/cupertino.dart';

import '../../Core/network/api_services.dart';
import '../../Core/network/services.dart';
import '../../Domain/entities/pre_save_inspection_entity.dart';
import '../../Domain/repositories/pre_save_inspection_repository.dart';
import '../model/response_model/inspection_pre_save_req_model.dart';
import '../model/response_model/inspection_pre_save_res_model.dart';


class PreSaveInspectionImpl implements PreSaveInspectionRepository {

  @override
  Future<PreSaveInspectionEntity> preSaveInspection({
    required String appointmentId,
    required String inspectedBy,
    required String vehicleId,
    required List<InspectionPreSaveReqModel> inspections,

  }) async {

    try {

      final response = await ApiService.preSaveInspectionMultipartUpload(
        appointmentId: appointmentId,
        inspectedBy: inspectedBy,
        vehicleId: vehicleId,
        inspections: inspections,
        apiUrl: savePreInspection,
      );

      final model = InspectionPreSaveResModel.fromJson(response!);

      return PreSaveInspectionEntity(
        status: model.status,
        message: model.message,
        data: model.data,
      );

    } catch (e) {
      throw Exception(e);
    }

  }

}