import 'package:ats_app/Domain/entities/inspection_new_que_entity.dart';



abstract class InspectionNewQueRepository {
  Future<InspectionNewQueEntity> newQuestionApi();
}