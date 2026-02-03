import 'package:ats_app/Data/model/response_model/vehicle_parts_res_model.dart';
import 'package:ats_app/Domain/entities/vehicle_parts_entity.dart';
import 'package:ats_app/Domain/usecases/vehicle_parts_usecases.dart';
import 'package:ats_app/Presentation/provider/vehicle_class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../Data/model/request_model/vehicle_parts_req_model.dart';
import '../../widgets/custom_loader.dart';


class VehiclePartsProvider extends ChangeNotifier{
  VehiclePartsUseCases vehiclePartsUseCases;

  VehiclePartsProvider({required this.vehiclePartsUseCases});

  bool isLoading = true;

  VehiclePartsEntity? vehiclePartsEntity;
  List<PartsDataModel> currentPageData = [];

   int currentPage = 0;
   int itemsPerPage = 2;
  int currentStep = 0;
  int get totalPages => (vehiclePartsEntity!.data!.length / itemsPerPage).ceil();

  int itemsPerPageForTablet = 4;
  int get totalPagesForTablet => (vehiclePartsEntity!.data!.length / itemsPerPageForTablet).ceil();

  void resetPage(){
  currentPage = 0;
  currentStep = 0;
}

  void previousPage() {
    if (currentStep > 0) {
      currentStep--;
      currentPage = (currentPage - 1).clamp(0, currentPage);
      notifyListeners();
    }
  }

  void nextStepper(){
    if(currentStep < totalPages){
      currentStep++;
      notifyListeners();
    }
  }

  void nextPage(){
    if(currentPage < totalPages - 1){
      currentPage++;
      notifyListeners();
    }
  }

  void resetStepper() {
    currentStep--;
    currentPageData = getCurrentPageData();
    notifyListeners();
  }

  List<PartsDataModel> getCurrentPageData() {
    final startIndex = (currentPage * itemsPerPage).clamp(0, vehiclePartsEntity!.data!.length);
    final endIndex = ((currentPage + 1) * itemsPerPage).clamp(0, vehiclePartsEntity!.data!.length);
    return vehiclePartsEntity!.data!.sublist(startIndex, endIndex);
  }

  List<PartsDataModel> getCurrentPageDataForTablet() {
    final startIndex = (currentPage * itemsPerPageForTablet).clamp(0, vehiclePartsEntity!.data!.length);
    final endIndex = ((currentPage + 1) * itemsPerPageForTablet).clamp(0, vehiclePartsEntity!.data!.length);
    return vehiclePartsEntity!.data!.sublist(startIndex, endIndex);
  }


  Future<VehiclePartsEntity?> vehiclePartsApi(BuildContext context)async{
    final classProvider = Provider.of<VehicleClassProvider>(context,listen: false);
    isLoading = true;
    resetPage();
    try {
      VehiclePartsReqModel vehiclePartsReqModel = VehiclePartsReqModel(
          vehicleClass: classProvider.selectedClass?.vehicleClass.toString()
      );
      vehiclePartsEntity = await vehiclePartsUseCases.execute(vehiclePartsReqModel);
      return vehiclePartsEntity;
    } catch (e) {
      vehiclePartsEntity = null;
    } finally {
      CustomLoader.closeLoader();
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

}