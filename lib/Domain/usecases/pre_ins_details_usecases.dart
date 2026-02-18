import 'package:ats_app/Data/model/request_model/pre_ins_details_req_model.dart';
import 'package:ats_app/Domain/entities/pre_ins_details_entity.dart';
import 'package:ats_app/Domain/repositories/pre_ins_details_repository.dart';
import 'package:flutter/cupertino.dart';

class PreInsDetailsUseCases {
  PreInsDetailsRepository preInsDetailsRepository;

  PreInsDetailsUseCases({required this.preInsDetailsRepository});

  Future<PreInsDetailsEntity> execute(PreInsDetailsReqModel preInsDetailsReqModel){
    return preInsDetailsRepository.preInspectionDetails(preInsDetailsReqModel);
  }
}