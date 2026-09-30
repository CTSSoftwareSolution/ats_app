import 'package:ats_app/Data/model/request_model/ai_result_req_model.dart';
import 'package:ats_app/Domain/entities/ai_result_entity.dart';
import 'package:ats_app/Domain/usecases/ai_inspection_details_usecases.dart';
import 'package:ats_app/Domain/usecases/ai_result_usecases.dart';
import 'package:ats_app/Presentation/provider/vehicle_class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Data/model/request_model/pre_inspection_details_req_model.dart';
import '../../Data/model/response_model/pre_inspection_details_model.dart';
import '../../Domain/entities/pre_inspection_details_entity.dart';
import '../../widgets/custom_loader.dart';
import 'inspection_form_provider.dart';

class AiResultProvider extends ChangeNotifier{
  AiResultUseCases aiResultUseCases;

  AiResultProvider({required this.aiResultUseCases});

  AiResultEntity? aiResultEntity;

  bool isLoading = false;


  Future<AiResultEntity?> aiResultDetails(BuildContext context) async{


    final classProvider = Provider.of<VehicleClassProvider>(context,listen: false);


    try {

      isLoading = true;
      notifyListeners();

      AiResultReqModel aiResultReqModel = AiResultReqModel(
          vehicleId: classProvider.selectedClass?.registrationNo,
          appointmentId:  "",
          documentId: null
      );
      aiResultEntity = await aiResultUseCases.execute(aiResultReqModel);
      if (aiResultEntity?.data != null) {
        //  formProvider.loadFromDetailsModel(aiDetailsEntity!.data!);
        debugPrint("AI Details${aiResultEntity!.data.toString()}");
      }
      return aiResultEntity;
    } catch (e) {
      aiResultEntity = null;
    } finally {
      isLoading = false;
      CustomLoader.closeLoader();

      notifyListeners();
    }
    return null;
  }




}