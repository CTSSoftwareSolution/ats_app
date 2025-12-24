import 'dart:async';

import 'package:ats_app/Presentation/provider/slider_provider.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../widgets/custom_image.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SliderProvider>(context);
    final sliderData = provider.sliderEntity?.data;

    if (sliderData == null || sliderData.isEmpty) {
      return SizedBox(
        height: 180,
        child: Center(
          child: CustomLoader.loader()
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: appColor,width: 2),
        borderRadius: BorderRadius.circular(7),
      ),
      height: 180,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: provider.pageController,
            itemCount: sliderData.length,
            onPageChanged: (index) {
              provider.setCurrentIndex(index);
              },
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child:
                  Image.network(sliderData[index].images.toString(),width: double.infinity,fit: BoxFit.cover)
                //CustomImage(image: sliderData[index].images.toString(),width: double.infinity,fit: BoxFit.cover,switchToNetwork: true,),
              );
            },
          ),


          Positioned(
            bottom: 12,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  color: indicatorContainerColor
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0,horizontal: 3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    sliderData.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                                          margin: const EdgeInsets.symmetric(horizontal: 2.5),
                                          width:  10,
                                          height: 10,
                                          decoration: BoxDecoration(
                        color: provider.currentIndex == index
                            ? appColor
                            : indicatorColor,
                        shape: BoxShape.circle,
                                          ),
                                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
