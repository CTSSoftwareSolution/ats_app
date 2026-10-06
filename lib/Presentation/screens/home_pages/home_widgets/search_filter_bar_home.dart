import 'package:ats_app/Presentation/provider/lane_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../VehicleFilterChip.dart';
import '../../../../utilities/color_data.dart';
import '../../../../utilities/new_app_theme/app_radius.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';
import '../../../../utilities/new_app_theme/app_text.dart';
import '../../../../widgets/custom_search_bar.dart';
import '../../../provider/vehicle_class_provider.dart';


class SearchFilterBarHome extends StatefulWidget {
  final VehicleClassProvider provider;
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
      color: bg,
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.page, AppSpacing.md, AppSpacing.page, AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSearchTextField(
            onChanged: (v) => widget.provider.onSearchChanged(context, v),
              controller: widget.provider.searchController,
              suffixIcon: widget.provider.searchValue.isEmpty
                  ? null
                  : SearchClearButton(
                onPressed: () {
                  widget.provider.searchController.clear();
                  widget.provider.vehicleClassApi(context: context, loadMore: false);
                },
              )
          ),
          const SizedBox(height: AppSpacing.md),
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

  final VehicleClassProvider vehicleProvider;
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
        const Text('CATEGORY', style: AppText.overline),
        const SizedBox(height: AppSpacing.sm),
        chipsProvider.isLoading ? const ChipShimmer() : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: chipsProvider.laneMap.keys.map((laneName) {
              final laneCode = chipsProvider.laneMap[laneName];
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
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
      height: 40,
      child: Shimmer.fromColors(
        baseColor: surface2,
        highlightColor: surface,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 6,
          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
          itemBuilder: (context, index) {
            return Container(
              width: 80,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            );
          },
        ),
      ),
    );
  }
}
