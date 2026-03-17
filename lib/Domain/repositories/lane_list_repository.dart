

import 'package:ats_app/Domain/entities/lane_list_entity.dart';
import 'package:flutter/cupertino.dart';

abstract class LaneListRepository {
  Future<LaneListEntity> laneListApi();
}