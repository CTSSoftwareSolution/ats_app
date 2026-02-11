

import 'package:ats_app/Data/model/request_model/login_req_model.dart';
import 'package:ats_app/Domain/entities/inspection_que_entity.dart';
import 'package:ats_app/Domain/entities/login_entity.dart';
import 'package:ats_app/Domain/repositories/inspection_que_repository.dart';


import '../repositories/login_repository.dart';

class InspectionQueUseCases {
  InspectionQueRepository inspectionQueRepository;

  InspectionQueUseCases({required this.inspectionQueRepository});

  Future<InspectionQueEntity> execute(){
    return inspectionQueRepository.questionApi();
  }
}