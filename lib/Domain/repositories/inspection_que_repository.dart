import 'package:ats_app/Domain/entities/inspection_que_entity.dart';

abstract class InspectionQueRepository {
  Future<InspectionQueEntity> questionApi();
}