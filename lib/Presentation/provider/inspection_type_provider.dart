import 'package:ats_app/Domain/entities/inspection_type_entity.dart';
import 'package:ats_app/Domain/usecases/inspection_type_usecases.dart';
import 'package:flutter/widgets.dart';

import '../../widgets/custom_loader.dart';

class InspectionTypeProvider extends ChangeNotifier{
  InspectionTypeUseCases inspectionTypeUseCases;

  InspectionTypeProvider({required this.inspectionTypeUseCases});

  InspectionTypeEntity? inspectionTypeEntity;

  bool isLoading = true;


  Future<InspectionTypeEntity?> getInspectionType()async{

    isLoading = true;

    try {
      inspectionTypeEntity = await inspectionTypeUseCases.execute();
      return inspectionTypeEntity;
    } catch (e) {
      inspectionTypeEntity = null;
    } finally {
      CustomLoader.closeLoader();
      isLoading = false;
      notifyListeners();
    }
    return null;
  }
}