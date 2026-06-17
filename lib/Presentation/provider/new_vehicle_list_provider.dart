import 'dart:async';

import 'package:ats_app/Data/model/request_model/vehicle_class_req_model.dart';
import 'package:ats_app/Domain/usecases/new_vehicle_list_usecases.dart';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../Data/model/request_model/new_vehicle_list_req_model.dart';
import '../../Data/model/response_model/new_vehicle_list_res_model.dart';
import '../../Data/model/response_model/vehicle_class_res_model.dart';
import '../../Domain/entities/new_vehicle_list_entity.dart';
import '../../Domain/entities/vehicle_class_entity.dart';
import '../../Domain/usecases/vehicle_class_usecases.dart';


class NewVehicleListProvider extends ChangeNotifier {
  NewVehicleListUseCases newVehicleListUseCases;

  NewVehicleListProvider({required this.newVehicleListUseCases});

  NewVehicleListEntity? newVehicleListEntity;
  bool isLoading = false;
  bool isLoadMore = false;
  bool hasMoreData = true;
  int page = 1;
  final int pageSize = 20;
  final searchController = TextEditingController();
  String searchValue = "";
  Timer? debounce;
  Rows? rowsDataModel;

  int? selectedIndex;


  //Filter State
  final List<String> filterOptions = ['All', 'LMV', 'HMV', 'MCWG', 'EV'];
  String _selectedFilter = 'All';
  String get selectedFilter => _selectedFilter;

  void onFilterChanged(BuildContext context, String filter) {
    if (_selectedFilter == filter) return;
    _selectedFilter = filter;
    notifyListeners();
    vehicleListApi(context: context, loadMore: false);
  }

  Rows? get selectedVehicle => rowsDataModel;
  void setSelectedClass(Rows data) {
    //vehicleEntity = _mapAppointmentToVehicleEntry(data);
    rowsDataModel = data;
  }

  void onSearchChanged(BuildContext context, String value) {
    searchValue = value;
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      vehicleListApi(context: context, loadMore: false);

    });
  }



  Future<NewVehicleListEntity?> vehicleListApi({
    required BuildContext context,
    bool loadMore = false,
  }) async {
    if (!loadMore) {
      isLoading = true;
      isLoadMore = false;
      newVehicleListEntity = null;
      page = 1;
      hasMoreData = true;
      //notifyListeners();
    } else {
      if (!hasMoreData) return null;
      isLoadMore = true;
      notifyListeners();
    }
    try {
      NewVehicleListReqModel reqModel = NewVehicleListReqModel(
        pageNo: page,
        pageSize: pageSize,
        status: 0
      );
      final response = await newVehicleListUseCases.execute(reqModel);
      if (response.data?.rows?.isNotEmpty ?? false) {
        // final appProvider = context.read<AppProvider>();

        if (loadMore && newVehicleListEntity != null) {
          newVehicleListEntity!.data!.rows!.addAll(response.data!.rows!);


        } else {
          newVehicleListEntity = response;

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