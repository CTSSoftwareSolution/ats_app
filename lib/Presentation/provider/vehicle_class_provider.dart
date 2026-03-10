import 'dart:async';

import 'package:ats_app/Data/model/request_model/vehicle_class_req_model.dart';
import 'package:flutter/cupertino.dart';
import '../../Data/model/response_model/vehicle_class_res_model.dart';
import '../../Domain/entities/vehicle_class_entity.dart';
import '../../Domain/usecases/vehicle_class_usecases.dart';

class VehicleClassProvider extends ChangeNotifier {
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
  Timer? debounce;
  Appointments? classDataModel;

  //Filter State
  final List<String> filterOptions = ['All', 'LMV', 'HMV', 'MCWG', 'EV'];
  String _selectedFilter = 'All';
  String get selectedFilter => _selectedFilter;

  void onFilterChanged(BuildContext context, String filter) {
    if (_selectedFilter == filter) return;
    _selectedFilter = filter;
    notifyListeners();
    vehicleClassApi(context: context, loadMore: false);
  }

  Appointments? get selectedClass => classDataModel;
  void setSelectedClass(Appointments data) {
    classDataModel = data;
  }

  void onSearchChanged(BuildContext context, String value) {
    searchValue = value;
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      vehicleClassApi(context: context);
    });
  }

  Future<VehicleClassEntity?> vehicleClassApi({
    required BuildContext context,
    bool loadMore = false,
  }) async {
    if (!loadMore) {
      isLoading = true;
      isLoadMore = false;
      vehicleClassEntity = null;
      page = 1;
      hasMoreData = true;
      notifyListeners();
    } else {
      if (!hasMoreData) return null;
      isLoadMore = true;
      notifyListeners();
    }
    try {
      VehicleClassReqModel vehicleClassReqModel = VehicleClassReqModel(
        searchText: searchController.text,
        pageNo: page,
        pageSize: pageSize,
        vehicleCategory: _selectedFilter == 'All' ? '' : _selectedFilter,
      );
      final response = await vehicleClassUseCases.execute(vehicleClassReqModel);
      if (response.data?.appointments?.isNotEmpty ?? false) {
        if (loadMore && vehicleClassEntity != null) {
          vehicleClassEntity!.data!.appointments!
              .addAll(response.data!.appointments!);
        } else {
          vehicleClassEntity = response;
        }
        page++;
      } else {
        hasMoreData = false;
      }
    } catch (e) {
      hasMoreData = false;
    } finally {
      isLoading = false;
      isLoadMore = false;
      notifyListeners();
    }
    return null;
  }
}