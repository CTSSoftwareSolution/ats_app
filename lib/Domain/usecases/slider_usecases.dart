import 'package:ats_app/Domain/entities/slider_entity.dart';
import 'package:ats_app/Domain/repositories/slider_repository.dart';


class SliderUseCases {
  SliderRepository sliderRepository;

  SliderUseCases({required this.sliderRepository});

  Future<SliderEntity> execute(){
    return sliderRepository.sliderApi();
  }
}