
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../VehicleFilterChip.dart';
import '../../../../widgets/custom_search_bar.dart';
import '../../../provider/vehicle_class_provider.dart';

class SearchFilterBarHome extends StatelessWidget {
  final VehicleClassProvider provider;
  const SearchFilterBarHome({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F6FB),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSearchTextField(
            onChanged: (v) => provider.onSearchChanged(context, v),
            onCloseClick: () {
              provider.searchController.clear();
              context.read<VehicleClassProvider>().onFilterChanged(context,"");
            },
            controller: provider.searchController,
          ),
          const SizedBox(height: 12),
          _FilterRow(provider: provider),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final VehicleClassProvider provider;
  const _FilterRow({required this.provider});

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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: provider.filterOptions.map((filter) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: VehicleFilterChip(
                  label: filter,
                  isSelected: provider.selectedFilter == filter,
                  onTap: () => provider.onFilterChanged(context, filter),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
