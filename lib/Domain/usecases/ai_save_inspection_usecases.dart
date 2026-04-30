import 'package:ats_app/Domain/entities/ai_save_inspection_entity.dart';
import 'package:ats_app/Domain/repositories/ai_save_inspection_repository.dart';

import '../../Data/model/response_model/inspection_pre_save_req_model.dart';
import '../entities/pre_save_inspection_entity.dart';


class AISaveInspectionUseCase {

  final AISaveInspectionRepository repository;

  AISaveInspectionUseCase({required this.repository});

  Future<AiSaveInspectionEntity> execute({
    required String appointmentId,
    required String inspectedBy,
    required String vehicleId,
    required List<InspectionPreSaveReqModel> inspections,

  }) {
    return repository.aiSaveInspection(
      appointmentId: appointmentId,
      inspectedBy: inspectedBy,
      vehicleId: vehicleId,
      inspections: inspections,

    );

  }

}