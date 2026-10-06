import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/section_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utilities/color_data.dart';
import '../../../../utilities/new_app_theme/app_spacing.dart';

import '../../../../widgets/new_app_ui/app_state_view.dart';
import '../../../provider/inspection_form_provider.dart';
import 'category_card.dart';
import 'inspection_view_rules.dart';

/// One tab of the inspection (Pre / Post / Under-PIT): section summary
/// followed by its categories, filtered by the active question filter.
class SectionTabView extends StatelessWidget {
  final int sectionIndex;

  const SectionTabView({super.key, required this.sectionIndex});

  @override
  Widget build(BuildContext context) {
    return Consumer<InspectionFormProvider>(
      builder: (context, provider, _) {
        final sections = provider.visibleSections;

        if (sections.isEmpty || sectionIndex >= sections.length) {
          return _buildEmptyState(provider);
        }

        final section = sections[sectionIndex];

        if (section.categories.isEmpty) {
          return _buildEmptyState(provider);
        }

        final anyShown = section.categories.any(
          (c) =>
              c.questions.any((q) => matchesQuestionFilter(q, provider.filter)),
        );

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: SectionSummaryCard(section: section)),
            if (!anyShown)
              SliverToBoxAdapter(child: _buildEmptyState(provider))
            else
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
    final filter = provider.filter;
    final (
      IconData icon,
      Color color,
      String title,
      String? message,
    ) = switch (filter) {
      QuestionFilter.answered => (
        Icons.pending_actions_outlined,
        na,
        'Nothing answered yet',
        'Answers you give in this section will show here.',
      ),
      QuestionFilter.unanswered => (
        Icons.task_alt_rounded,
        pass,
        'All questions answered',
        'Every check in this section has an answer.',
      ),
      QuestionFilter.no => (
        Icons.verified_outlined,
        pass,
        'No failed checks',
        'Nothing in this section was answered "No".',
      ),
      QuestionFilter.all => (
        Icons.inbox_outlined,
        na,
        'No questions found',
        null,
      ),
    };
    return Center(
      child: SingleChildScrollView(
        child: AppStateView(
          icon: icon,
          color: color,
          title: title,
          message: message,
        ),
      ),
    );
  }
}
