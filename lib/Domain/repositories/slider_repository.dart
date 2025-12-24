import '../entities/slider_entity.dart';

abstract class SliderRepository {
  Future<SliderEntity> sliderApi();
}