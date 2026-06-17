import 'package:ats_app/Data/model/request_model/ai_update_result_req_model.dart';
import 'package:ats_app/Domain/entities/ai_update_result_entity.dart';
import 'package:ats_app/Domain/usecases/ai_update_result_usecases.dart';
import 'package:ats_app/Presentation/provider/new_vehicle_list_provider.dart';
import 'package:ats_app/Presentation/provider/vehicle_class_provider.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_loader.dart';
import 'ai_inspection_details_provider.dart';

class AiUpdateResultProvider extends ChangeNotifier{
  AiUpdateResultUseCases resultUseCases;

  AiUpdateResultProvider({required this.resultUseCases});

  bool isLoading = false;
  AiUpdateResultEntity? aiUpdateResultEntity;

  bool _toPass = false;

  bool get toPass => _toPass;

  set toPass(bool value) {
    _toPass = value;
    notifyListeners();
  }
  final ctrl = TextEditingController();
  int chars = 0;

  Future<AiUpdateResultEntity?> aiUpdateResult(BuildContext context, bool statusResult) async{
    final vehicleListProvider = Provider.of<NewVehicleListProvider>(context,listen: false);
    final detailsProvider = Provider.of<AiInspectionDetailsProvider>(context,listen: false);
    try{
      isLoading = true;
      notifyListeners();

      AiUpdateResultReqModel updateResultReqModel = AiUpdateResultReqModel(
        vehicleNo: vehicleListProvider.selectedVehicle?.registrationNo,
        appointmentId: vehicleListProvider.selectedVehicle?.appointmentId,
        questionId: detailsProvider.selectedQueId,
        aiInspectionResult: statusResult == true ? "Pass" : "Fail",
        aiRemark: ctrl.text
      );
      aiUpdateResultEntity = await  resultUseCases.execute(updateResultReqModel);
      await detailsProvider.aiInspectionDetails(context);
      context.pop();
      return aiUpdateResultEntity;
    }catch (e){
      aiUpdateResultEntity = null;
    } finally {
      CustomLoader.closeLoader();

      notifyListeners();
    }
    return null;
  }
}