import 'package:ats_app/Presentation/screens/pre_inspection_form/inspection_widgets/section_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/inspection_form_provider.dart';
import 'category_card.dart';

class SectionTabView extends StatelessWidget {
  final int sectionIndex;

  const SectionTabView({super.key, required this.sectionIndex,});

  @override
  Widget build(BuildContext context) {
    return Consumer<InspectionFormProvider>(
      builder: (context, provider, _) {
        if (provider.filteredSections.isEmpty ||
            sectionIndex >= provider.filteredSections.length) {
          return _buildEmptyState(provider);
        }

        final section = provider.filteredSections[sectionIndex];

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
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(InspectionFormProvider provider) {
    final isAnsweredFilter = provider.filter == QuestionFilter.answered;
    final isPendingFilter = provider.filter == QuestionFilter.unanswered;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isAnsweredFilter
                ? Icons.check_circle_outline
                : isPendingFilter
                ? Icons.pending_outlined
                : Icons.inbox_outlined,
            size: 56,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            isAnsweredFilter
                ? 'No answered questions in this section'
                : isPendingFilter
                ? 'All questions answered in this section!'
                : 'No questions found',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}