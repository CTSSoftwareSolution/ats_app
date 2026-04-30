import 'package:ats_app/Data/model/request_model/manual_inspection_request.dart';
import 'package:ats_app/Domain/entities/manual_inspection_entity.dart';


abstract class ManualInspectionRepository {
  Future<ManualInspectionEntity> getManualInspectionRepository(ManualInspectionRequest request);
}

