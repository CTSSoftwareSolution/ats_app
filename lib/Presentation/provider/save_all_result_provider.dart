import 'package:ats_app/Data/model/request_model/save_all_result_req_model.dart';
import 'package:ats_app/Domain/entities/save_all_result_entity.dart';
import 'package:ats_app/Domain/usecases/save_all_result_usecases.dart';
import 'package:ats_app/Presentation/provider/vehicle_class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_loader.dart';

class SaveAllResultProvider extends ChangeNotifier{
  SaveAllResultUseCases saveAllResultUseCases;

  SaveAllResultProvider({required this.saveAllResultUseCases});

  SaveAllResultEntity? saveAllResultEntity;

  bool isLoading = false;

  /// Saves all results of the selected vehicle. Returns null when the request
  /// fails or another save is already in flight.
  Future<SaveAllResultEntity?> saveAllAiResult(BuildContext context) async{
    if (isLoading) return null;

    final classProvider = Provider.of<VehicleClassProvider>(context,listen: false);

    try {

      isLoading = true;
      notifyListeners();

      SaveAllResultReqModel saveAllResultReqModel = SaveAllResultReqModel(
          vehicleId: classProvider.selectedClass?.registrationNo,
          appointmentId:  classProvider.selectedClass?.appointmentId?.toString()
      );
      saveAllResultEntity = await saveAllResultUseCases.execute(saveAllResultReqModel);
      if (saveAllResultEntity?.data != null) {

        debugPrint("AI Details${saveAllResultEntity!.data.toString()}");
      }
      return saveAllResultEntity;
    } catch (e) {
      saveAllResultEntity = null;
    } finally {
      isLoading = false;
      CustomLoader.closeLoader();

      notifyListeners();
    }
    return null;
  }



}