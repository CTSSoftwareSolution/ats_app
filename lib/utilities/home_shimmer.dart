import 'package:ats_app/utilities/extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/custom_image.dart';
import '../widgets/custom_text.dart';
import 'color_data.dart';
import 'image_data.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});



  @override
  Widget build(BuildContext context) {

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              Row(
                children: [
                  CustomImage(image: logoImage,height: 28.0,width: 28.0,),
                  15.width,
                  CustomText(text: "ATS Corporation", fontSize: 24.0, fontFamily: "Black",)
                ],
              ),
           
              25.height,
          
          
              Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          
              30.height,
          
          
              GridView.builder(
                itemCount: 4,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.6,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  );
                },
              ),
              60.height,
              CustomText(text: "Scan, Detect", fontFamily: "Heavy", fontSize: 46.0,textColor: scanTextColor,),
              Row(
                children: [
                  CustomText(text: "Drive Safe", fontFamily: "Heavy", fontSize: 46.0,textColor: scanTextColor,),
                 10.width,
                  CustomImage( image: heartIcon,scale: 4,),
                ],
              ),
              20.height,
              CustomImage(scale: 4, image: dividerImage,),
            20.height,
              Row(
                children: [
                  CustomImage(image: logoImage,height: 18.0,width: 18.0,),
                  10.width,
                  CustomText(text: "ATS Corporation", fontSize: 15.0, fontFamily: "Black",)
                ],
              ),
             40.height
          
            ],
          ),
        ),
      ),
    );
  }
}
