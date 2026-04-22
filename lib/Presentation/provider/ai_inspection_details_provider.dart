import 'package:ats_app/Domain/usecases/ai_inspection_details_usecases.dart';
import 'package:ats_app/Presentation/provider/vehicle_class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../Data/model/request_model/pre_inspection_details_req_model.dart';
import '../../Domain/entities/pre_inspection_details_entity.dart';
import '../../widgets/custom_loader.dart';

class AiInspectionDetailsProvider extends ChangeNotifier{
  AIInspectionDetailsUseCases aiInspectionDetailsUseCases;

  AiInspectionDetailsProvider({required this.aiInspectionDetailsUseCases});

  PreInspectionDetailsEntity? aiDetailsEntity;

  bool isLoading = false;

  Future<PreInspectionDetailsEntity?> aiInspectionDetails(BuildContext context) async{

    final classProvider = Provider.of<VehicleClassProvider>(context,listen: false);
    try {
      PreInspectionDetailsReqModel detailsReqModel = PreInspectionDetailsReqModel(
          vehicleId: classProvider.selectedClass?.registrationNo,
        appointmentId:  classProvider.selectedClass?.appointmentId
      );
      aiDetailsEntity = await aiInspectionDetailsUseCases.execute(detailsReqModel);
      notifyListeners();
      return aiDetailsEntity;
    } catch (e) {
      aiDetailsEntity = null;
    } finally {
      CustomLoader.closeLoader();
      isLoading = false;
      notifyListeners();
    }
    return null;
  }
}