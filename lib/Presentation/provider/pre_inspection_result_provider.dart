import 'package:ats_app/Data/model/request_model/pre_inspection_result_req_model.dart';
import 'package:ats_app/Domain/entities/inspection_que_entity.dart';
import 'package:ats_app/Domain/entities/pre_inspection_result_entity.dart';
import 'package:ats_app/Domain/usecases/inspection_que_usecases.dart';
import 'package:ats_app/Domain/usecases/pre_inspection_result_usecases.dart';
import 'package:flutter/cupertino.dart';

import '../../widgets/custom_loader.dart';

class PreInspectionResultProvider extends ChangeNotifier{
  PreInspectionResultUseCases preInspectionResultUseCases;

  PreInspectionResultProvider({required this.preInspectionResultUseCases});

  bool isLoading = true;

  PreInspectionResultEntity? preInspectionResultEntity;



  Future<PreInspectionResultEntity?> saveResultApi()async{

    isLoading = true;

    try {
      PreInspectionResultReqModel resultReqModel = PreInspectionResultReqModel(
        vehicleNo: "",
        inspectedBy: "",
        results: []
      );

      preInspectionResultEntity = await preInspectionResultUseCases.execute(resultReqModel);
      return preInspectionResultEntity;
    } catch (e) {
      preInspectionResultEntity = null;
    } finally {
      CustomLoader.closeLoader();
      isLoading = false;
      notifyListeners();
    }
    return null;
  }



}