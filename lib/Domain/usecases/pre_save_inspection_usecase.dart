
import 'package:flutter/cupertino.dart';

import '../../Data/model/response_model/inspection_pre_save_req_model.dart';
import '../entities/pre_save_inspection_entity.dart';
import '../repositories/pre_save_inspection_repository.dart';

class PreSaveInspectionUseCase {

  final PreSaveInspectionRepository repository;

  PreSaveInspectionUseCase({required this.repository});

  Future<PreSaveInspectionEntity> execute({
    required String appointmentId,
    required String inspectedBy,
    required String vehicleId,
    required List<InspectionPreSaveReqModel> inspections,

  }) {
    return repository.preSaveInspection(
      appointmentId: appointmentId,
      inspectedBy: inspectedBy,
      vehicleId: vehicleId,
      inspections: inspections,

    );

  }

}