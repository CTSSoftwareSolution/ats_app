import 'package:ats_app/Presentation/provider/lane_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../VehicleFilterChip.dart';
import '../../../../utilities/color_data.dart';
import '../../../../utilities/image_data.dart';
import '../../../../widgets/custom_image.dart';
import '../../../../widgets/custom_search_bar.dart';
import '../../../provider/new_vehicle_list_provider.dart';
import '../../../provider/vehicle_class_provider.dart';


class SearchFilterBarHome extends StatefulWidget {
  final NewVehicleListProvider provider;
  const SearchFilterBarHome({super.key, required this.provider});

  @override
  State<SearchFilterBarHome> createState() => _SearchFilterBarHomeState();
}

class _SearchFilterBarHomeState extends State<SearchFilterBarHome> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LaneListProvider>().fetchLanes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chipsProvider = context.watch<LaneListProvider>();
    return Container(
      color: const Color(0xFFF4F6FB),
      padding: const EdgeInsets.fromLTRB(16, 3, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSearchTextField(
            onChanged: (v) => widget.provider.onSearchChanged(context, v),
              controller: widget.provider.searchController,
              suffixIcon: widget.provider.searchValue.isEmpty
                  ? null
                  : IconButton(
                icon: Container(
                  height: 18.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    color: greyLightColor,
                  ),
                  child: CustomImage(image: closeIcon, scale: 3.5),
                ),
                onPressed: () {
                  widget.provider.searchController.clear();
                  widget.provider.vehicleListApi(context: context, loadMore: false);
                },
                color: blackColor,
              )
          ),
          const SizedBox(height: 12),
          _FilterRow(
            vehicleProvider: widget.provider,
            chipsProvider: chipsProvider,
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {

  final NewVehicleListProvider vehicleProvider;
  final LaneListProvider chipsProvider;

  const _FilterRow({
    required this.vehicleProvider,
    required this.chipsProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Filter by Category',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.black54,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        chipsProvider.isLoading ? const ChipShimmer() : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: chipsProvider.laneMap.keys.map((laneName) {
              final laneCode = chipsProvider.laneMap[laneName];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: VehicleFilterChip(
                  label: laneName,
                  isSelected:
                  chipsProvider.selectedFilter == laneName,
                  onTap: () => chipsProvider.onChipSelected(
                    laneName,
                    onChanged: () => vehicleProvider.onFilterChanged(context, laneCode!),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class ChipShimmer extends StatelessWidget {
  const ChipShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 80,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }
}