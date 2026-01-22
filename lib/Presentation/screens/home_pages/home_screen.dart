import 'package:ats_app/Presentation/screens/home_pages/select_vehicle.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/home_shimmer.dart';
import '../../provider/slider_provider.dart';
import '../../provider/vehicle_type_provider.dart';
import 'image_slider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    context.read<SliderProvider>().startAutoSlide();
    context.read<VehicleTypeProvider>().vehicleTypeApi();
    context.read<SliderProvider>(). sliderApi();
  }

  @override
  Widget build(BuildContext context) {
    final bool isHomeLoading =
        context.watch<SliderProvider>().isLoading || context.watch<VehicleTypeProvider>().isLoading;
    return Scaffold(
     body: SafeArea(
         child:  isHomeLoading
             ? const HomeShimmer()
             :
         SingleChildScrollView(
           padding: EdgeInsets.only(bottom: 40.0),
           physics: BouncingScrollPhysics(),
           child: Padding(
             padding: const EdgeInsets.symmetric(vertical: 30.0,horizontal: 15.0),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 Row(
                   children: [
                     CustomImage(image: logoImage,height: 28.0,width: 28.0,),
                     15.width,
                     CustomText(text: "ATS Corporation", fontSize: 24.0, fontFamily: "Black",)
                   ],
                 ),
                 25.height,
                 ImageSlider(),
                 30.height,
                 SelectVehicle(),
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
         )
     ),

    );
  }
}
