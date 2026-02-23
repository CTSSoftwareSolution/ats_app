import 'package:ats_app/Presentation/provider/vehicle_type_provider.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/home_shimmer_responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    context.read<VehicleTypeProvider>().vehicleTypeApi();
  }

  @override
  Widget build(BuildContext context) {
    final bool isHomeLoading =
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
