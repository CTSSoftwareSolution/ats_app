import 'dart:async';

import 'package:flutter/cupertino.dart';
import '../../Domain/entities/slider_entity.dart';
import '../../Domain/usecases/slider_usecases.dart';
import '../../widgets/custom_loader.dart';

class SliderProvider extends ChangeNotifier {
  SliderUseCases sliderUseCases;

  SliderProvider({required this.sliderUseCases});


  SliderEntity? sliderEntity;
  bool isLoading = true;

  final PageController pageController = PageController();
  Timer? timer;
  int currentIndex = 0;

  void setCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void startAutoSlide() {
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (sliderEntity == null || sliderEntity!.data!.isEmpty) return;

      if (currentIndex < sliderEntity!.data!.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }

      pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    });
  }

  Future<SliderEntity?> sliderApi() async {
    isLoading = true;
    try {
      sliderEntity = await sliderUseCases.execute();
      // if (sliderEntity != null && sliderEntity!.data!.isNotEmpty) {
      //   startAutoSlide();
      // }
    } catch (e) {
      sliderEntity = null;
    } finally {
      CustomLoader.closeLoader();
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  @override
  void dispose() {
    timer?.cancel();
    pageController.dispose();
    super.dispose();
  }
}
