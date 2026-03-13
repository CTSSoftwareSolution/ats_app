

import 'package:ats_app/Data/model/request_model/manual_inspection_request.dart';
import 'package:ats_app/Domain/entities/manual_inspection_entity.dart';
import 'package:ats_app/Domain/repositories/manual_inspection_repository.dart';


class ManualInspectionListUseCase {
  ManualInspectionRepository manualInspectionRepository;

  ManualInspectionListUseCase({required this.manualInspectionRepository});

  Future<ManualInspectionEntity> execute(ManualInspectionRequest request){
    return manualInspectionRepository.getManualInspectionRepository(request);
  }
}