import 'package:ats_app/Domain/entities/inspection_type_entity.dart';
import 'package:ats_app/Domain/repositories/inspection_type_repository.dart';
import 'package:flutter/cupertino.dart';

class InspectionTypeUseCases {
  InspectionTypeRepository inspectionTypeRepository;

  InspectionTypeUseCases({required this.inspectionTypeRepository});

  Future<InspectionTypeEntity> execute(){
    return inspectionTypeRepository.getInspectionType();
  }
}