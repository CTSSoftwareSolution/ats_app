import 'package:ats_app/Data/model/request_model/pre_ins_manual_status_req_model.dart';
import 'package:ats_app/Domain/entities/pre_ins_manual_status_entity.dart';
import 'package:ats_app/Domain/usecases/pre_ins_manual_status_usecases.dart';
import 'package:ats_app/Presentation/provider/vehicle_class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_loader.dart';

class PreInsManualStatusProvider extends ChangeNotifier{
  PreInsManualStatusUseCases preInsManualStatusUseCases;

  PreInsManualStatusProvider({required this.preInsManualStatusUseCases});

  PreInsManualStatusEntity? preInsManualStatusEntity;

  bool isLoading = false;

  Future<PreInsManualStatusEntity?> getManualStatusApi(BuildContext context) async{

    final classProvider = Provider.of<VehicleClassProvider>(context,listen: false);
    try {
      PreInsManualStatusReqModel statusReqModel = PreInsManualStatusReqModel(
        vehicleNo: classProvider.selectedClass?.regNo,
      );

      preInsManualStatusEntity = await preInsManualStatusUseCases.execute(statusReqModel);
      return preInsManualStatusEntity;
    } catch (e) {
      preInsManualStatusEntity = null;
    } finally {
      CustomLoader.closeLoader();
      isLoading = false;
      notifyListeners();
    }
    return null;
  }
}