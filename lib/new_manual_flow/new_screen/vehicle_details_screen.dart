import 'package:ats_app/new_manual_flow/new_screen/report_screen.dart';
import 'package:ats_app/new_manual_flow/new_screen/vehicle_photos_screen.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';
import 'package:ats_app/widgets/new_app_ui/app_top_bar.dart';
import 'package:provider/provider.dart';

import '../../utilities/new_app_theme/app_icon_size.dart';
import '../../utilities/new_app_theme/app_spacing.dart';
import '../../utilities/new_app_theme/app_text.dart';
import '../../widgets/new_app_ui/app_card.dart';
import '../../widgets/new_app_ui/app_icon_tile.dart';
import '../../widgets/new_app_ui/app_progress_bar.dart';
import '../../widgets/new_app_ui/app_state_view.dart';
import '../../widgets/new_app_ui/bottom_action_bar.dart';
import '../../widgets/new_app_ui/primary_button.dart';
import '../../widgets/new_app_ui/registration_plate.dart';
import '../../widgets/new_app_ui/secondary_button.dart';
import '../../widgets/new_app_ui/status_badge.dart';
import '../app_provider.dart';
import '../auth_provider.dart';
import '../debug_log_overlay.dart';
import '../new_model/auth_model.dart';
import '../new_model/inspection_model.dart';
import '../new_model/vehicle_entry.dart';
import '../new_model/vehicle_photos_model.dart';
import '../new_widget/logout_dialog.dart';
import 'inspection_flow_screen.dart';

/// Vehicle details and inspection hub for one appointment.
///
///   [PLATE]                    [In progress]
///   Make Model · Customer
///   ── Vehicle information ──────────────────
///   ── Appointment information ──────────────
///   ── Inspection information ───────────────
///   ── Inspection status ─── 1 of 3 steps ──
///   ▰▰▰▰▱▱▱▱
///   ① Vehicle photos            [Done]    ›
///   ② Pre-inspection checks     [4/20]    ›
///   ③ Post-inspection checks    [Locked]  ›
///   ─────────────────────────────────────────
///   [Report]  [ Continue: Pre-inspection  → ]
class VehicleDetailScreen extends StatelessWidget {
  final String vehicleId;
  const VehicleDetailScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    final config = context.watch<AuthProvider>().config;
    return Consumer<AppProvider>(
      builder: (_, prov, __) {
        VehicleEntry? v;
        for (final e in prov.vehicles) {
          if (e.regNo == vehicleId) {
            v = e;
            break;
          }
        }
        final steps = v == null
            ? const <_Step>[]
            : _inspectionSteps(context, v, vehicleId, config);

        return DebugFabWrapper(
          child: Scaffold(
            backgroundColor: bg,
            appBar: AppTopBar(
              title: 'Vehicle details',
              onBack: () => Navigator.pop(context),
              actions: [
                IconButton(
                  tooltip: 'Log out',
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: textWhite,
                    size: AppIconSize.md,
                  ),
                  onPressed: () => confirmLogout(context),
                ),
              ],
            ),
            body: v == null
                ? _MissingVehicleState(provider: prov)
                : _VehicleDetailBody(vehicle: v, steps: steps),
            bottomNavigationBar: v == null
                ? null
                : _ActionBar(vehicle: v, vehicleId: vehicleId, steps: steps),
          ),
        );
      },
    );
  }
}

// ── Inspection steps ─────────────────────────────────────────────────────────

/// One step of the inspection workflow as shown on this screen.
class _Step {
  final int number;
  final String phase;
  final IconData icon;
  final String title;
  final String subtitle;
  final int done;
  final int total;

  /// Non-null when the step can't be opened yet; shown on the row.
  final String? lockedReason;
  final VoidCallback onTap;

  const _Step({
    required this.number,
    required this.phase,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.done,
    required this.total,
    this.lockedReason,
    required this.onTap,
  });

  bool get locked => lockedReason != null;
  bool get complete => total > 0 && done >= total;
}

/// The three steps, with the same lock rules and destinations as before.
/// The step rows and the bottom "Continue" button both use these handlers.
List<_Step> _inspectionSteps(
  BuildContext context,
  VehicleEntry v,
  String vehicleId,
  AppConfig config,
) {
  void snack(String msg) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(msg)));

  final totalPhotos = VehiclePhotoAngle.values.length;
  final preLocked = config.requirePhotosForPre && !v.photosComplete;
  final postLocked = config.requirePreForPost && !v.preAllDone;

  return [
    _Step(
      number: 1,
      phase: 'Pre-inspection',
      icon: Icons.photo_camera_outlined,
      title: 'Vehicle photos',
      subtitle: v.photosComplete
          ? 'All $totalPhotos angles captured'
          : 'Front, rear, sides, engine and more',
      done: v.photoCount,
      total: totalPhotos,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VehiclePhotosScreen(vehicleId: vehicleId),
        ),
      ),
    ),
    _Step(
      number: 2,
      phase: 'Pre-inspection',
      icon: Icons.assignment_outlined,
      title: 'Pre-inspection checks',
      subtitle: v.preAllDone
          ? 'All ${v.preTotalItems} checks completed'
          : 'Lamps, safety, body, tyres…',
      done: v.preDoneCount,
      total: v.preTotalItems,
      lockedReason: preLocked ? 'Complete the vehicle photos first' : null,
      onTap: preLocked
          ? () => snack('Complete $totalPhotos vehicle photos first')
          : () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => InspectionFlowScreen(
                  vehicleId: vehicleId,
                  phase: InspectionPhase.pre,
                ),
              ),
            ),
    ),
    _Step(
      number: 3,
      phase: 'Post-inspection',
      icon: Icons.assignment_turned_in_outlined,
      title: 'Post-inspection checks',
      subtitle: v.postAllDone
          ? 'All ${v.postTotalItems} checks completed'
          : 'Brakes, emission, protection…',
      done: v.postDoneCount,
      total: v.postTotalItems,
      lockedReason: postLocked ? 'Complete the pre-inspection checks first' : null,
      onTap: postLocked
          ? () => snack('Complete pre-inspection checks first')
          : () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => InspectionFlowScreen(
                  vehicleId: vehicleId,
                  phase: InspectionPhase.post,
                ),
              ),
            ),
    ),
  ];
}

/// First step that is open and not finished, if any.
_Step? _nextStep(List<_Step> steps) {
  for (final s in steps) {
    if (!s.locked && !s.complete) return s;
  }
  return null;
}

// ── Bottom action bar ────────────────────────────────────────────────────────

/// Primary: continue with the next open step (same handler as its row).
/// Secondary: the inspection report, once anything has been recorded.
/// When every step is finished, the report becomes the primary action.
class _ActionBar extends StatelessWidget {
  final VehicleEntry vehicle;
  final String vehicleId;
  final List<_Step> steps;

  const _ActionBar({
    required this.vehicle,
    required this.vehicleId,
    required this.steps,
  });

  void _openReport(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => ReportScreen(vehicleId: vehicleId)),
  );

  @override
  Widget build(BuildContext context) {
    final next = _nextStep(steps);
    final hasReport = vehicle.doneCount > 0;
    if (next == null && !hasReport) return const SizedBox.shrink();

    if (next == null) {
      return BottomActionBar(
        child: PrimaryButton(
          label: 'View inspection report',
          icon: Icons.summarize_rounded,
          onPressed: () => _openReport(context),
        ),
      );
    }

    final started = next.done > 0;
    final primary = PrimaryButton(
      label: '${started ? 'Continue' : 'Start'}: ${next.title}',
      icon: Icons.arrow_forward_rounded,
      onPressed: next.onTap,
    );
    return BottomActionBar(
      child: hasReport
          ? Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: 'Report',
                    icon: Icons.summarize_outlined,
                    onPressed: () => _openReport(context),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(flex: 2, child: primary),
              ],
            )
          : primary,
    );
  }
}

/// Loading / error / not-found states when [VehicleDetailScreen.vehicleId]
/// isn't in the loaded list.
class _MissingVehicleState extends StatelessWidget {
  final AppProvider provider;
  const _MissingVehicleState({required this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider.loadingVehicles) {
      return const AppLoadingView(message: 'Loading vehicle…');
    }
    final error = provider.vehicleError;
    return Center(
      child: SingleChildScrollView(
        child: error != null
            ? AppStateView.error(
                title: "Couldn't load this vehicle",
                message: error,
                onAction: provider.loadVehicles,
              )
            : AppStateView.empty(
                icon: Icons.directions_car_outlined,
                title: 'Vehicle not found',
                message:
                    'This appointment is no longer in the list. Go back and pick it again.',
                actionLabel: 'Go back',
                actionIcon: Icons.arrow_back_rounded,
                onAction: () => Navigator.pop(context),
              ),
      ),
    );
  }
}

// ── Body ─────────────────────────────────────────────────────────────────────

class _VehicleDetailBody extends StatelessWidget {
  final VehicleEntry vehicle;
  final List<_Step> steps;
  const _VehicleDetailBody({required this.vehicle, required this.steps});

  @override
  Widget build(BuildContext context) {
    final v = vehicle;
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.lg,
        AppSpacing.page,
        AppSpacing.xl,
      ),
      children: [
        _IdentityCard(vehicle: v),
        const SizedBox(height: AppSpacing.section),
        _InfoSection(
          icon: Icons.directions_car_outlined,
          title: 'Vehicle information',
          rows: [
            ('Class', v.vehicleClass),
            ('Fuel', v.fuelType),
            ('Engine no.', v.engineNo),
            ('Chassis no.', v.chassisNo),
            ('Emission norms', v.emissionNorms),
          ],
        ),
        const SizedBox(height: AppSpacing.section),
        _InfoSection(
          icon: Icons.event_note_outlined,
          title: 'Appointment information',
          rows: [
            ('Booking ID', v.bookingId),
            ('Test date', v.testDate),
            ('Lane', v.laneName),
            ('Contact', v.customerContact),
          ],
        ),
        const SizedBox(height: AppSpacing.section),
        _InfoSection(
          icon: Icons.fact_check_outlined,
          title: 'Inspection information',
          rows: [
            ('Test no.', v.testNo),
            ('RTO', v.rtoDistrict),
            ('Fitness expiry', v.fitnessExpiry),
          ],
        ),
        const SizedBox(height: AppSpacing.section),
        _StatusSection(steps: steps),
      ],
    );
  }
}

// ── Section header ───────────────────────────────────────────────────────────

/// Icon + H2 title above a section card, with an optional right-hand item.
class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;

  const _SectionTitle({required this.icon, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Semantics(
        header: true,
        child: Row(
          children: [
            Icon(icon, size: AppIconSize.md, color: appColor),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.sectionTitle,
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.sm),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

// ── Identity card: plate, status, make/model, customer ───────────────────────

class _IdentityCard extends StatelessWidget {
  final VehicleEntry vehicle;
  const _IdentityCard({required this.vehicle});

  /// Overall inspection status for this vehicle.
  StatusBadge _overallBadge() {
    switch (vehicle.status) {
      case InspectionStatus.pending:
        return const StatusBadge.pending(label: 'Not started');
      case InspectionStatus.photosOnly:
        return const StatusBadge.captured(label: 'Photos captured');
      case InspectionStatus.inProgress:
        return const StatusBadge.inProgress();
      case InspectionStatus.completed:
        return vehicle.overallResult == 'UNFIT'
            ? const StatusBadge.fail(label: 'Unfit')
            : const StatusBadge.pass(label: 'Fit');
    }
  }

  @override
  Widget build(BuildContext context) {
    final v = vehicle;
    final title = '${v.make} ${v.model}'.trim();
    final customer = v.customerName.trim();
    final failed =
        v.status == InspectionStatus.completed && v.overallResult == 'UNFIT';

    return Semantics(
      container: true,
      label: 'Vehicle ${v.displayName}',
      child: AppCard(
        borderColor: failed ? fail.withValues(alpha: 0.35) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RegistrationPlate(
                      number: v.displayName,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                // Capped so a long label never squeezes the plate.
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 160),
                  child: _overallBadge(),
                ),
              ],
            ),
            if (title.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.sectionTitle,
              ),
            ],
            if (customer.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  const Icon(
                    Icons.person_outline_rounded,
                    size: AppIconSize.xs,
                    color: na,
                  ),
                  const SizedBox(width: AppSpacing.iconGap),
                  Expanded(
                    child: Text(
                      customer,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodySecondary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Information sections (label / value rows) ────────────────────────────────

class _InfoSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<(String, String)> rows;

  const _InfoSection({
    required this.icon,
    required this.title,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    final shown = rows.where((r) => r.$2.trim().isNotEmpty).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(icon: icon, title: title),
        if (shown.isEmpty)
          const AppCard(
            child: Text('No details available.', style: AppText.bodySecondary),
          )
        else
          AppCard(
            padding: EdgeInsets.zero,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Two columns on wide screens, one on phones.
                final twoColumns = constraints.maxWidth >= 520;
                final cells = [
                  for (final r in shown) _InfoCell(label: r.$1, value: r.$2),
                ];
                if (!twoColumns) {
                  return Column(
                    children: [
                      for (var i = 0; i < cells.length; i++) ...[
                        if (i > 0)
                          const Divider(height: 1, indent: AppSpacing.card),
                        cells[i],
                      ],
                    ],
                  );
                }
                return Column(
                  children: [
                    for (var i = 0; i < cells.length; i += 2) ...[
                      if (i > 0)
                        const Divider(height: 1, indent: AppSpacing.card),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: cells[i]),
                          Expanded(
                            child: i + 1 < cells.length
                                ? cells[i + 1]
                                : const SizedBox(),
                          ),
                        ],
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;
  const _InfoCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.card,
      vertical: AppSpacing.md,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: Text(label, style: AppText.bodySecondary)),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          flex: 3,
          child: Text(value, textAlign: TextAlign.right, style: AppText.label),
        ),
      ],
    ),
  );
}

// ── Inspection status: overall progress + the three steps ────────────────────

class _StatusSection extends StatelessWidget {
  final List<_Step> steps;
  const _StatusSection({required this.steps});

  @override
  Widget build(BuildContext context) {
    final finished = steps.where((s) => s.complete).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(
          icon: Icons.timeline_rounded,
          title: 'Inspection status',
          trailing: Text(
            '$finished of ${steps.length} steps',
            style: AppText.caption.copyWith(fontFeatures: AppText.tabular),
          ),
        ),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.card),
                child: AppProgressBar.thick(
                  value: steps.isEmpty ? 0 : finished / steps.length,
                ),
              ),
              for (final step in steps) ...[
                const Divider(height: 1),
                _StepRow(step: step),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  final _Step step;
  const _StepRow({required this.step});

  @override
  Widget build(BuildContext context) {
    final s = step;
    final Color tint = s.locked
        ? na
        : s.complete
        ? pass
        : appColor;
    final progress = s.total > 0 ? (s.done / s.total).clamp(0.0, 1.0) : 0.0;

    final StatusBadge badge = s.locked
        ? const StatusBadge.neutral(
            label: 'Locked',
            icon: Icons.lock_outline_rounded,
            dense: true,
          )
        : s.complete
        ? const StatusBadge.completed(label: 'Done', dense: true)
        : s.done > 0
        ? StatusBadge.inProgress(label: '${s.done}/${s.total}', dense: true)
        : const StatusBadge.pending(label: 'To do', dense: true);

    return Semantics(
      button: true,
      label:
          'Step ${s.number}, ${s.title}. ${s.lockedReason ?? (s.complete ? 'Done' : '${s.done} of ${s.total}')}',
      excludeSemantics: true,
      child: InkWell(
        onTap: s.onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 72),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.card,
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
            ),
            child: Row(
              children: [
                AppIconTile(
                  icon: s.locked
                      ? Icons.lock_outline_rounded
                      : s.complete
                      ? Icons.check_rounded
                      : s.icon,
                  color: tint,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STEP ${s.number} · ${s.phase.toUpperCase()}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.overline,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        s.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.title.copyWith(
                          color: s.locked ? textSecondary : textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        s.lockedReason ?? s.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.caption,
                      ),
                      if (!s.locked && !s.complete && s.done > 0) ...[
                        const SizedBox(height: AppSpacing.sm),
                        AppProgressBar(value: progress),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                badge,
                const Icon(
                  Icons.chevron_right_rounded,
                  color: textSecondary,
                  size: AppIconSize.lg,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
