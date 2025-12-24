import 'package:ats_app/Data/model/request_model/vehicle_class_req_model.dart';
import 'package:ats_app/Presentation/provider/vehicle_type_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../Data/model/response_model/vehicle_class_res_model.dart';
import '../../Domain/entities/vehicle_class_entity.dart';
import '../../Domain/usecases/vehicle_class_usecases.dart';
import '../../widgets/custom_loader.dart';

class VehicleClassProvider extends ChangeNotifier{
  VehicleClassUseCases vehicleClassUseCases;

  VehicleClassProvider({required this.vehicleClassUseCases});

  VehicleClassEntity? vehicleClassEntity;
  bool isLoading = false;

  bool isLoadMore = false;
  bool hasMoreData = true;

  int page = 1;
  final int pageSize = 20;

  final searchController = TextEditingController();
  String searchValue = "";

  ClassDataModel? classDataModel;
  ClassDataModel? get selectedClass => classDataModel;
  void setSelectedClass(ClassDataModel data){
    classDataModel = data;
  }

  Future<VehicleClassEntity?> vehicleClassApi(BuildContext context,{bool loadMore = false}) async {
    final typeProvider = Provider.of<VehicleTypeProvider>(context,listen: false);
    if (!loadMore) {
      isLoading = true;
      isLoadMore = false;

      vehicleClassEntity = null;
      page = 1;

      //notifyListeners();
    } else {
      isLoadMore = true;
      notifyListeners();
    }
    try {
      VehicleClassReqModel vehicleClassReqModel = VehicleClassReqModel(
        vehicleClass: typeProvider.selectedType?.vehicleType.toString(),
        search: searchController.text,
        page: page,
        pageSize: pageSize
      );

      final response = await vehicleClassUseCases.execute(vehicleClassReqModel);

      if (response.data?.isNotEmpty ?? false) {
        if (loadMore && vehicleClassEntity != null) {
          vehicleClassEntity!.data!.addAll(response.data!);
        } else {
          vehicleClassEntity = response;
        }
        page++;
      } else {
        hasMoreData = false;
      }

    } catch (e) {
      hasMoreData  = false;
    } finally {
      isLoading = false;
      isLoadMore = false;
      notifyListeners();
    }
    return null;
  }
}