import 'package:ats_app/Domain/entities/lane_list_entity.dart';
import 'package:ats_app/Domain/usecases/lane_list_usecase.dart';
import 'package:flutter/material.dart';

class LaneListProvider extends ChangeNotifier {

  final LaneListUseCase laneListUseCase;

  LaneListProvider({required this.laneListUseCase});

  LaneListEntity? laneListData;
  bool isLoading = false;
  String _selectedFilter = 'All';
  String get selectedFilter => _selectedFilter;

  Map<String, String> get laneMap {
    final Map<String, String> map = {'All': 'All'};
    final lanes = laneListData?.data;
    if (lanes != null && lanes.isNotEmpty) {
      for (final lane in lanes) {
        final laneName = lane.laneName;
        final laneCode = lane.laneCode;
        if (laneName != null && laneName.isNotEmpty && laneCode != null) {
          map[laneName] = laneCode;
        }
      }
    }
    return map;
  }

  Future<void> fetchLanes(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      laneListData = await laneListUseCase.execute();
    } catch (e) {
      laneListData = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void onChipSelected(String filter, {VoidCallback? onChanged}) {
    if (_selectedFilter == filter) return;
    _selectedFilter = filter;
    notifyListeners();
    onChanged?.call();
  }

  void resetFilter() {
    _selectedFilter = 'All';
    notifyListeners();
  }
}