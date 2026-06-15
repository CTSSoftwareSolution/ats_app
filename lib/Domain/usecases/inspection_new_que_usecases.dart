import 'package:ats_app/Domain/entities/inspection_que_entity.dart';
import 'package:ats_app/Domain/repositories/inspection_que_repository.dart';

import '../entities/inspection_new_que_entity.dart';
import '../repositories/inspection_new_que_repository.dart';



class InspectionNewQueUseCases {
  InspectionNewQueRepository inspectionNewQueRepository;

  InspectionNewQueUseCases({required this.inspectionNewQueRepository});

  Future<InspectionNewQueEntity> execute(){
    return inspectionNewQueRepository.newQuestionApi();
  }
}