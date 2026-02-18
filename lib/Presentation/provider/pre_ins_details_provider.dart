import 'package:ats_app/Data/model/request_model/pre_ins_details_req_model.dart';
import 'package:ats_app/Domain/entities/pre_ins_details_entity.dart';
import 'package:ats_app/Domain/usecases/pre_ins_details_usecases.dart';
import 'package:ats_app/Presentation/provider/vehicle_class_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_loader.dart';

class PreInsDetailsProvider extends ChangeNotifier{
  PreInsDetailsUseCases preInsDetailsUseCases;

  PreInsDetailsProvider({required this.preInsDetailsUseCases});

  PreInsDetailsEntity? preInsDetailsEntity;



   bool isLoading = false;

  Future<PreInsDetailsEntity?> getPreInsDetailsApi(BuildContext context) async{

    final classProvider = Provider.of<VehicleClassProvider>(context,listen: false);
    try {
      PreInsDetailsReqModel detailsReqModel = PreInsDetailsReqModel(
          vehicleNo: classProvider.selectedClass?.regNo,

      );

      preInsDetailsEntity = await preInsDetailsUseCases.execute(detailsReqModel);
      return preInsDetailsEntity;
    } catch (e) {
      preInsDetailsEntity = null;
    } finally {
      CustomLoader.closeLoader();
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  }


