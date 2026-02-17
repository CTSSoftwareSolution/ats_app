import 'package:ats_app/Domain/entities/inspection_type_entity.dart';
import 'package:flutter/cupertino.dart';

abstract class InspectionTypeRepository {
  Future<InspectionTypeEntity> getInspectionType();
}