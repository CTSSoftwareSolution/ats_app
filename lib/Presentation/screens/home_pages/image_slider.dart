import 'package:ats_app/Presentation/provider/slider_provider.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';


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
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Colors.white,
            ),
          ),
        ),
      );
    }
    return SizedBox(
      height: 180,
      child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              controller: provider.pageController,
              itemCount: sliderData.length,
              allowImplicitScrolling: true,
              onPageChanged: (index) {
                provider.setCurrentIndex(index);
                },
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child:
                    Image.network(sliderData[index].images.toString(),width: double.infinity,fit: BoxFit.cover,gaplessPlayback: true,
                      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                        if (frame == null && !wasSynchronouslyLoaded) {
                          return SizedBox(
                            height: 180,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: appColor, width: 2),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: child,
                        );
                      },
                    )

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



