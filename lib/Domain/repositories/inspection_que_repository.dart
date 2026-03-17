import 'package:ats_app/Domain/entities/inspection_que_entity.dart';
import 'package:flutter/cupertino.dart';

abstract class InspectionQueRepository {
  Future<InspectionQueEntity> questionApi();
}