import 'dart:async';
import 'package:ats_app/Data/model/request_model/manual_inspection_request.dart';
import 'package:ats_app/Data/model/response_model/manual_inspection_list_model.dart';
import 'package:ats_app/Domain/entities/manual_inspection_entity.dart';
import 'package:ats_app/Domain/usecases/manual_inspection_list_usecase.dart';
import 'package:flutter/cupertino.dart';
import '../../Domain/entities/vehicle_class_entity.dart';

class ManualInspectionListProvider extends ChangeNotifier {

  ManualInspectionListUseCase manualInspectionListUseCase;

  ManualInspectionListProvider({required this.manualInspectionListUseCase});

  ManualInspectionEntity? manualInspectionEntity;
  bool isLoading = false;
  bool isLoadMore = false;
  bool hasMoreData = true;
  int page = 1;
  final int pageSize = 20;
  final searchController = TextEditingController();
  String searchValue = "";
  Timer? debounce;
  ManualLisAppointments? manualLisAppointments;

  bool isManualInspectionScreen = false;
  void setManualInspectionScreen(bool isManualInspection) {
    isManualInspectionScreen = isManualInspection;
    notifyListeners();
  }


  void onSearchChanged(BuildContext context, String value) {
    searchValue = value;
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      manualInspectionListAPI(context: context);
    });
  }

  void onFilterChanged(BuildContext context) {
    searchController.text="";
    manualInspectionListAPI(context: context, loadMore: false);
    notifyListeners();
  }

  ManualLisAppointments? get selectedManualListData => manualLisAppointments;
  void setSelectedManualListData(ManualLisAppointments data) {
    manualLisAppointments = data;
    notifyListeners();
  }


  Future<VehicleClassEntity?> manualInspectionListAPI({
    required BuildContext context,
    bool loadMore = false,
  }) async {
    if (!loadMore) {
      isLoading = true;
      isLoadMore = false;
      manualInspectionEntity = null;
      page = 1;
      hasMoreData = true;
      notifyListeners();
    } else {
      if (!hasMoreData) return null;
      isLoadMore = true;
      notifyListeners();
    }
    try {
      ManualInspectionRequest vehicleClassReqModel = ManualInspectionRequest(
        searchText: searchController.text,
        pageNo: page,
        pageSize: pageSize,
      );
      final response = await manualInspectionListUseCase.execute(vehicleClassReqModel);
      if (response.data?.appointments?.isNotEmpty ?? false) {
        if (loadMore && manualInspectionEntity != null) {
          manualInspectionEntity!.data!.appointments!
              .addAll(response.data!.appointments!);
        } else {
          manualInspectionEntity = response;
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