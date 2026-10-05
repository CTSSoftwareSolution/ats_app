import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/section_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utilities/app_theme.dart';
import '../../../../utilities/color_data.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';
import '../../../../widgets/app_ui.dart';

import '../../../../widgets/new_app_ui/app_state_view.dart';
import '../../../provider/inspection_form_provider.dart';
import 'category_card.dart';

class SectionTabView extends StatelessWidget {
  final int sectionIndex;

  const SectionTabView({super.key, required this.sectionIndex,});

  @override
  Widget build(BuildContext context) {
    return Consumer<InspectionFormProvider>(
      builder: (context, provider, _) {
        final sections = provider.visibleSections;

        if (sections.isEmpty ||
            sectionIndex >= sections.length) {
          return _buildEmptyState(provider);
        }

        final section = provider.visibleSections[sectionIndex];
        debugPrint("SECTION NAME = ${section.label}");
        debugPrint("CATEGORY COUNT = ${section.categories.length}");
        // if (provider.filteredSections.isEmpty ||
        //     sectionIndex >= provider.filteredSections.length) {
        //   return _buildEmptyState(provider);
        // }
        //
        // final section = provider.filteredSections[sectionIndex];
        debugPrint('→ Section: ${section.label}');
        debugPrint('→ Section: ${sectionIndex}');

        if (section.categories.isEmpty) {
          return _buildEmptyState(provider);
        }

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
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(InspectionFormProvider provider) {
    final isAnsweredFilter = provider.filter == QuestionFilter.answered;
    final isPendingFilter = provider.filter == QuestionFilter.unanswered;
    return Center(
      child: SingleChildScrollView(
        child: AppStateView(
          icon: isAnsweredFilter
              ? Icons.check_circle_outline
              : isPendingFilter
              ? Icons.pending_outlined
              : Icons.inbox_outlined,
          color: isPendingFilter ? pass : textMuted,
          title: isAnsweredFilter
              ? 'No answered questions in this section'
              : isPendingFilter
              ? 'All questions answered in this section!'
              : 'No questions found',
        ),
      ),
    );
  }
}
