import 'dart:async';

import 'package:ats_app/Data/model/request_model/vehicle_class_req_model.dart';
import 'package:ats_app/new_manual_flow/new_model/vehicle_entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../Data/model/response_model/vehicle_class_res_model.dart';
import '../../Domain/entities/vehicle_class_entity.dart';
import '../../Domain/usecases/vehicle_class_usecases.dart';
import '../../new_manual_flow/app_provider.dart';

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

  int? selectedIndex;

  VehicleEntry? vehicleEntity;
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
   // vehicleEntity = _mapAppointmentToVehicleEntry(data);
    classDataModel = data;
  }

  void onSearchChanged(BuildContext context, String value) {
    searchValue = value;
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      vehicleClassApi(context: context, loadMore: false);

    });
  }


// Add a helper method to your provider:
//   VehicleEntry _mapAppointmentToVehicleEntry(Appointments appointment) {
//     return VehicleEntry(
//       id: const Uuid().v4(),
//       appointmentId: appointment.appointmentId?.toString() ?? '',
//       bookingId: appointment.bookingId ?? '',
//       regNo: appointment.registrationNo ?? appointment.regNo ?? '',
//       vehicleClass: appointment.vehicleClass ?? '',
//       make: appointment.make ?? '',
//       model: appointment.model ?? '',
//       fuelType: appointment.fuelType ?? '',
//       engineNo: appointment.engineNo ?? '',
//       chassisNo: appointment.vin ?? '',        // mapping vin → chassisNo
//       sections: [],                            // populate later as needed
//     );
//   }

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
      //notifyListeners();
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
      // final appProvider = context.read<AppProvider>();

        if (loadMore && vehicleClassEntity != null) {
          vehicleClassEntity!.data!.appointments!.addAll(response.data!.appointments!);
          // final newEntries = response.data!.appointments!
          //     .map(_mapAppointmentToVehicleEntry)
          //     .toList();
          // appProvider.vehicles.addAll(newEntries);
          // appProvider.notifyListeners();

        } else {
          vehicleClassEntity = response;
          // Replace AppProvider vehicles on fresh load
          // final allEntries = response.data!.appointments!
          //     .map(_mapAppointmentToVehicleEntry)
          //     .toList();
          // appProvider.vehicles
          //   ..clear()
          //   ..addAll(allEntries);
          // appProvider.notifyListeners();
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