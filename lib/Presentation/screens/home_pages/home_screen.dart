import 'package:ats_app/Presentation/provider/login_provider.dart';
import 'package:ats_app/Presentation/screens/home_pages/select_vehicle.dart';
import 'package:ats_app/Presentation/screens/login_page/login_screen.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/image_data.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:ats_app/widgets/custom_image.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/home_shimmer.dart';
import '../../../widgets/custom_dialog_box.dart';
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
    final sliderProvider = Provider.of<SliderProvider>(context, listen: false);
    sliderProvider.sliderApi();
    final typeProvider = Provider.of<VehicleTypeProvider>(context, listen: false);
    typeProvider.vehicleTypeApi();
  }

  @override
  Widget build(BuildContext context) {

    final sliderProvider = context.watch<SliderProvider>();
    final vehicleProvider = context.watch<VehicleTypeProvider>();
    final bool isHomeLoading =
        sliderProvider.isLoading || vehicleProvider.isLoading;
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
                     SizedBox(width: 15.0,),
                     CustomText(text: "ATS Corporation", fontSize: 24.0, fontFamily: "Black",)
                   ],
                 ),
                 SizedBox(height: 25.0,),
                 ImageSlider(),
                 SizedBox(height: 30.0,),
                 SelectVehicle(),
                 SizedBox(height: 60.0,),
                 CustomText(text: "Scan, Detect", fontFamily: "Heavy", fontSize: 46.0,textColor: scanTextColor,),
                 Row(
                   children: [
                     CustomText(text: "Drive Safe", fontFamily: "Heavy", fontSize: 46.0,textColor: scanTextColor,),
                     SizedBox(width: 10.0,),
                     CustomImage( image: heartIcon,scale: 4,),
                   ],
                 ),
                 SizedBox(height: 20.0,),
                 CustomImage(scale: 4, image: dividerImage,),
                 SizedBox(height: 20.0,),
                 Row(
                   children: [
                     CustomImage(image: logoImage,height: 18.0,width: 18.0,),
                     SizedBox(width: 10.0,),
                     CustomText(text: "ATS Corporation", fontSize: 15.0, fontFamily: "Black",)
                   ],
                 ),
                 SizedBox(height: 40.0,),
               ],
             ),
           ),
         )
     ),

    );
  }
}
