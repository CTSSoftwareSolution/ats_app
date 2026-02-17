import 'package:flutter/cupertino.dart';

import '../entities/slider_entity.dart';

abstract class SliderRepository {
  Future<SliderEntity> sliderApi();
}