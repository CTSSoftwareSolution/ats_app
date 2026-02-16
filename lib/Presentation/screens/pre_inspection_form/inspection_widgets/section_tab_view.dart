
import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/section_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/inspection_form_provider.dart';
import 'category_card.dart';

class SectionTabView extends StatelessWidget {
  final int sectionIndex;
  const SectionTabView({super.key, required this.sectionIndex});

  @override
  Widget build(BuildContext context) {
    return Consumer<InspectionFormProvider>(
      builder: (context, provider, _) {
        if (provider.sections.isEmpty) return const SizedBox.shrink();
        final section = provider.sections[sectionIndex];

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SectionSummaryCard(section: section),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, catIndex) => CategoryCard(
                  sectionIndex: sectionIndex,
                  categoryIndex: catIndex,
                ),
                childCount: section.categories.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      },
    );
  }
}