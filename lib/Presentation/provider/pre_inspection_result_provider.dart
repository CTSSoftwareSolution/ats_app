import 'package:ats_app/Data/model/request_model/pre_inspection_result_req_model.dart';
import 'package:ats_app/Domain/entities/pre_inspection_result_entity.dart';
import 'package:ats_app/Domain/usecases/pre_inspection_result_usecases.dart';
import 'package:ats_app/Presentation/provider/vehicle_class_provider.dart';
import 'package:ats_app/Presentation/screens/vehicles_class_page/vehicle_class_screen.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_loader.dart';
import 'inspection_form_provider.dart';

class PreInspectionResultProvider extends ChangeNotifier{
  PreInspectionResultUseCases preInspectionResultUseCases;

  PreInspectionResultProvider({required this.preInspectionResultUseCases});

  bool isLoading = true;

  PreInspectionResultEntity? preInspectionResultEntity;

  Future<PreInspectionResultEntity?> saveResultApi(BuildContext context)async{
    final classProvider = Provider.of<VehicleClassProvider>(context,listen: false);
    final inspectionProvider = Provider.of<InspectionFormProvider>(context, listen: false);
    isLoading = true;
    CustomLoader.showLoader("Please wait...");
    final resultList = inspectionProvider.collectAnswers().map((value){
      return Results(
        inspectionResult: value.answer,
        questionId: int.tryParse(value.questionId.toString()),
        remarks: "",
        severityLevel: "",
        evidenceUrl: value.imagePath
      );
    }).toList();
    try {
      PreInspectionResultReqModel resultReqModel = PreInspectionResultReqModel(
        vehicleNo: classProvider.selectedClass?.regNo,
        inspectedBy: "",
        results: resultList
      );
      preInspectionResultEntity = await preInspectionResultUseCases.execute(resultReqModel);
     context.push(VehicleClassScreen());
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