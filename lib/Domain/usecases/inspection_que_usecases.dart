import 'package:ats_app/Domain/entities/inspection_que_entity.dart';
import 'package:ats_app/Domain/repositories/inspection_que_repository.dart';



class InspectionQueUseCases {
  InspectionQueRepository inspectionQueRepository;

  InspectionQueUseCases({required this.inspectionQueRepository});

  Future<InspectionQueEntity> execute(){
    return inspectionQueRepository.questionApi();
  }
}