import 'dart:async';

import 'package:ats_app/Data/model/request_model/ai_inspection_list_req_model.dart';
import 'package:ats_app/Data/model/response_model/ai_inspection_list_res_model.dart';
import 'package:ats_app/Data/model/response_model/vehicle_class_res_model.dart' as vehicle_class;
import 'package:ats_app/Domain/usecases/ai_inspection_list_usecases.dart';
import 'package:flutter/material.dart';

class AiInspectionListProvider extends ChangeNotifier {
  AiInspectionListUseCases aiInspectionListUseCases;

  AiInspectionListProvider({required this.aiInspectionListUseCases});

  /// Appointments loaded so far, across all fetched pages.
  final List<Appointments> appointments = [];

  bool isLoading = false;
  bool isLoadMore = false;
  bool hasMoreData = true;

  /// Set when the first page fails; shown with a retry action.
  String? errorMessage;

  int page = 1;
  final int pageSize = 20;
  final searchController = TextEditingController();
  String searchValue = "";
  Timer? debounce;

  void onSearchChanged(String value) {
    searchValue = value;
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      aiInspectedList();
    });
  }

  void clearSearch() {
    debounce?.cancel();
    searchController.clear();
    searchValue = "";
    aiInspectedList();
  }

  /// Loads the first page, or the next page when [loadMore] is true.
  Future<void> aiInspectedList({bool loadMore = false}) async {
    if (loadMore) {
      // No paging while any request is running or once the last page is in.
      if (isLoading || isLoadMore || !hasMoreData) return;
      isLoadMore = true;
    } else {
      if (isLoading) return;
      isLoading = true;
      isLoadMore = false;
      errorMessage = null;
      page = 1;
      hasMoreData = true;
    }
    notifyListeners();

    try {
      final requestModel = AiInspectionListReqModel(
        pageNo: page,
        pageSize: pageSize,
        searchText: searchController.text.trim(),
        status: null,
      );
      final response = await aiInspectionListUseCases.execute(requestModel);

      if (response.status == false) {
        _onFailure(loadMore, response.message);
        return;
      }

      final items = response.data?.appointments ?? [];
      if (!loadMore) appointments.clear();
      appointments.addAll(items);

      final total = response.data?.totalRecords;
      hasMoreData = total != null
          ? appointments.length < total
          : items.length >= pageSize;
      if (items.isEmpty) hasMoreData = false;
      page++;
    } catch (e) {
      debugPrint("AI Inspection List Error: $e");
      _onFailure(loadMore, null);
    } finally {
      isLoading = false;
      isLoadMore = false;
      notifyListeners();
    }
  }

  void _onFailure(bool loadMore, String? message) {
    if (loadMore) {
      // Keep the loaded pages; stop paging so scrolling doesn't spam retries.
      hasMoreData = false;
      return;
    }
    appointments.clear();
    final text = message?.trim() ?? "";
    errorMessage = text.isEmpty
        ? "Unable to load AI inspections. Please try again."
        : text;
  }

  /// Maps a list item to the appointment model the AI result flow reads
  /// from [VehicleClassProvider.selectedClass].
  vehicle_class.Appointments toSelectedClass(Appointments item) {
    return vehicle_class.Appointments(
      appointmentId: item.appointmentId,
      registrationNo: item.registrationNo,
      bookingId: item.bookingId,
      status: item.status,
      appointmentDate: item.appointmentDate,
      make: item.make,
      model: item.model,
    );
  }

  @override
  void dispose() {
    debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }
}
