import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SelectVehicleShimmer extends StatefulWidget {
  const SelectVehicleShimmer({super.key});

  @override
  State<SelectVehicleShimmer> createState() => _SelectVehicleShimmerState();
}

class _SelectVehicleShimmerState extends State<SelectVehicleShimmer> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: GridView.builder(
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
    );
  }
}
