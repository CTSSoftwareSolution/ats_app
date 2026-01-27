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
import 'home_screen_responsive.dart';
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
         child:
         isHomeLoading ? const HomeShimmer() :
         HomeScreenResponsive()
     ),

    );
  }
}
