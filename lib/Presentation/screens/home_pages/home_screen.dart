import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/home_shimmer_responsive.dart';
import '../../provider/slider_provider.dart';
import '../../provider/vehicle_type_provider.dart';
import 'home_screen_responsive.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
   //context.read<SliderProvider>().startAutoSlide();
    context.read<VehicleTypeProvider>().vehicleTypeApi();
   // context.read<SliderProvider>(). sliderApi();
  }

  @override
  Widget build(BuildContext context) {
    final bool isHomeLoading =
       // context.watch<SliderProvider>().isLoading ||
            context.watch<VehicleTypeProvider>().isLoading;
    return Scaffold(
      backgroundColor: background,
     body: SafeArea(
         child: isHomeLoading ?
         const HomeShimmerResponsive(): HomeScreenResponsive()
     ),

    );
  }
}
