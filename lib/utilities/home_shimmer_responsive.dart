import 'package:ats_app/utilities/home_shimmer.dart';
import 'package:ats_app/utilities/list_shimmer.dart';
import 'package:flutter/material.dart';

class HomeShimmerResponsive extends StatelessWidget {
  const HomeShimmerResponsive({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (context, orientation) {
          return
            orientation == Orientation.landscape ?
            Row(
              children: [
                Expanded(child: HomeShimmer()),
                VerticalDivider(),
                Expanded(child: ListShimmer()),
              ],
            ) :
            HomeShimmer();
        }
    );
  }
}
