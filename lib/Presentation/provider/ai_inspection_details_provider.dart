import 'package:ats_app/Domain/usecases/ai_inspection_details_usecases.dart';
import 'package:ats_app/Presentation/provider/vehicle_class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Data/model/request_model/pre_inspection_details_req_model.dart';
import '../../Data/model/response_model/pre_inspection_details_model.dart';
import '../../Domain/entities/pre_inspection_details_entity.dart';
import '../../widgets/custom_loader.dart';
import 'inspection_form_provider.dart';

class AiInspectionDetailsProvider extends ChangeNotifier{
  AIInspectionDetailsUseCases aiInspectionDetailsUseCases;

  AiInspectionDetailsProvider({required this.aiInspectionDetailsUseCases});

  PreInspectionDetailsEntity? aiDetailsEntity;

   bool isLoading = false;

  bool isAIMode = false;
  bool get isAIModeOn => isAIMode;

  int? questionId;
  int? get selectedQueId => questionId;
  void setSelectedQueId(int queId) {
    questionId = queId;
    notifyListeners();
  }

  void setAIMode(bool value) {
    isAIMode = value;
    notifyListeners();
  }

  Future<PreInspectionDetailsEntity?> aiInspectionDetails(BuildContext context) async{


    final classProvider = Provider.of<VehicleClassProvider>(context,listen: false);
    final formProvider = Provider.of<InspectionFormProvider>(context, listen: false);

    try {

      isLoading = true;
      notifyListeners();

      PreInspectionDetailsReqModel detailsReqModel = PreInspectionDetailsReqModel(
          vehicleId: classProvider.selectedClass?.registrationNo,
        appointmentId:  classProvider.selectedClass?.appointmentId
      );
      aiDetailsEntity = await aiInspectionDetailsUseCases.execute(detailsReqModel);
      if (aiDetailsEntity?.data != null) {
      //  formProvider.loadFromDetailsModel(aiDetailsEntity!.data!);
        debugPrint("AI Details${aiDetailsEntity!.data.toString()}");
      }
      return aiDetailsEntity;
    } catch (e) {
      aiDetailsEntity = null;
    } finally {
      CustomLoader.closeLoader();

      notifyListeners();
    }
    return null;
  }




  }