import 'package:ats_app/new_manual_flow/new_screen/report_screen.dart';
import 'package:ats_app/new_manual_flow/new_screen/vehicle_photos_screen.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';
import 'package:ats_app/widgets/new_app_ui/app_top_bar.dart';
import 'package:provider/provider.dart';

import '../../utilities/new_app_theme/app_icon_size.dart';
import '../../utilities/new_app_theme/app_radius.dart';
import '../../utilities/new_app_theme/app_spacing.dart';
import '../../utilities/new_app_theme/app_text.dart';
import '../../widgets/new_app_ui/app_card.dart';
import '../../widgets/new_app_ui/app_state_view.dart';
import '../../widgets/new_app_ui/bottom_action_bar.dart';
import '../../widgets/new_app_ui/info_chip.dart';
import '../../widgets/new_app_ui/primary_button.dart';
import '../../widgets/new_app_ui/registration_plate.dart';
import '../../widgets/new_app_ui/section_header.dart';
import '../../widgets/new_app_ui/status_badge.dart';
import '../app_provider.dart';
import '../auth_provider.dart';
import '../debug_log_overlay.dart';
import '../new_model/inspection_model.dart';
import '../new_model/vehicle_entry.dart';
import '../new_model/vehicle_photos_model.dart';
import '../new_widget/logout_dialog.dart';
import 'inspection_flow_screen.dart';

/// Vehicle details and inspection workflow hub for one appointment:
/// identity (plate, make/model, status) → vehicle details → the three
/// inspection steps, with the report as the bottom action.
class VehicleDetailScreen extends StatelessWidget {
  final String vehicleId;
  const VehicleDetailScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (_, prov, __) {
        VehicleEntry? v;
        for (final e in prov.vehicles) {
          if (e.regNo == vehicleId) {
            v = e;
            break;
          }
        }

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
                : _VehicleDetailBody(vehicle: v, vehicleId: vehicleId),
            bottomNavigationBar: (v != null && v.doneCount > 0)
                ? BottomActionBar(
                    child: PrimaryButton(
                      label: 'View inspection report',
                      icon: Icons.summarize_rounded,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReportScreen(vehicleId: vehicleId),
                        ),
                      ),
                    ),
                  )
                : null,
          ),
        );
      },
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

class _VehicleDetailBody extends StatelessWidget {
  final VehicleEntry vehicle;
  final String vehicleId;
  const _VehicleDetailBody({required this.vehicle, required this.vehicleId});

  void _snack(BuildContext ctx, String msg) =>
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    final v = vehicle;
    final config = context.watch<AuthProvider>().config;
    final totalPhotos = VehiclePhotoAngle.values.length;
    final preLocked = config.requirePhotosForPre && !v.photosComplete;
    final postLocked = config.requirePreForPost && !v.preAllDone;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.lg,
        AppSpacing.page,
        AppSpacing.xl,
      ),
      children: [
        _VehicleSummaryCard(vehicle: v),
        const SizedBox(height: AppSpacing.xl),

        const SectionHeader('Vehicle information'),
        _VehicleInfoCard(vehicle: v),
        const SizedBox(height: AppSpacing.xl),

        // PRE-INSPECTION
        _PhaseHeader(
          title: 'Pre-inspection',
          subtitle: 'Visual checks before the vehicle enters the test lane',
          isDone: v.preAllDone,
        ),
        _StepCard(
          step: 1,
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
        const SizedBox(height: AppSpacing.md),
        _StepCard(
          step: 2,
          icon: Icons.assignment_outlined,
          title: 'Pre-inspection checks',
          subtitle: v.preAllDone
              ? 'All ${v.preTotalItems} checks completed'
              : 'Lamps, safety, body, tyres…',
          done: v.preDoneCount,
          total: v.preTotalItems,
          lockedReason: preLocked ? 'Complete the vehicle photos first' : null,
          onTap: preLocked
              ? () => _snack(
                  context,
                  'Complete $totalPhotos vehicle photos first',
                )
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
        const SizedBox(height: AppSpacing.xl),

        // POST-INSPECTION
        _PhaseHeader(
          title: 'Post-inspection',
          subtitle: 'Checks after the automated tests in the lane',
          isDone: v.postAllDone,
        ),
        _StepCard(
          step: 3,
          icon: Icons.assignment_turned_in_outlined,
          title: 'Post-inspection checks',
          subtitle: v.postAllDone
              ? 'All ${v.postTotalItems} checks completed'
              : 'Brakes, emission, protection…',
          done: v.postDoneCount,
          total: v.postTotalItems,
          lockedReason: postLocked
              ? 'Complete the pre-inspection checks first'
              : null,
          onTap: postLocked
              ? () => _snack(context, 'Complete pre-inspection checks first')
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
      ],
    );
  }
}

// ── Summary card: plate, identity, status ───────────────────────────────────
class _VehicleSummaryCard extends StatelessWidget {
  final VehicleEntry vehicle;
  const _VehicleSummaryCard({required this.vehicle});

  /// Overall inspection status for this vehicle.
  StatusBadge _overallBadge() {
    switch (vehicle.status) {
      case InspectionStatus.pending:
        return const StatusBadge.neutral(
          label: 'Not started',
          icon: Icons.radio_button_unchecked_rounded,
        );
      case InspectionStatus.photosOnly:
        return const StatusBadge.captured(label: 'Photos captured');
      case InspectionStatus.inProgress:
        return const StatusBadge.processing(label: 'In progress');
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
    final chips = <Widget>[
      if (v.vehicleClass.trim().isNotEmpty)
        InfoChip(icon: Icons.tag_rounded, label: v.vehicleClass),
      if (v.fuelType.trim().isNotEmpty)
        InfoChip(icon: Icons.local_gas_station_outlined, label: v.fuelType),
      if (v.laneName.trim().isNotEmpty)
        InfoChip(icon: Icons.alt_route_rounded, label: v.laneName),
    ];

    // Three steps: photos, pre-inspection, post-inspection.
    final stepsDone =
        (v.photosComplete ? 1 : 0) +
        (v.preAllDone ? 1 : 0) +
        (v.postAllDone ? 1 : 0);

    return Semantics(
      container: true,
      label: 'Vehicle ${v.displayName}',
      child: AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.card),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status sits above the plate so the registration number
                  // always gets the full card width.
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'REGISTRATION NO.',
                          style: AppText.overline,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      // Capped rather than Flexible so the badge sits flush right.
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 180),
                        child: _overallBadge(),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RegistrationPlate(
                      number: v.displayName,
                      fontSize: 24,
                    ),
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
                  if (v.customerName.trim().isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      v.customerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodySecondary,
                    ),
                  ],
                  if (chips.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: chips,
                    ),
                  ],
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.card,
                AppSpacing.md,
                AppSpacing.card,
                AppSpacing.card,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Inspection progress', style: AppText.chip),
                      ),
                      Text('$stepsDone of 3 steps', style: AppText.caption),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: stepsDone / 3,
                      minHeight: 6,
                      backgroundColor: surface2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        stepsDone == 3 ? pass : appColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Vehicle information (label / value rows) ────────────────────────────────
class _VehicleInfoCard extends StatelessWidget {
  final VehicleEntry vehicle;
  const _VehicleInfoCard({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final v = vehicle;
    final rows = <(String, String)>[
      ('Booking ID', v.bookingId),
      ('Test date', v.testDate),
      ('Test no.', v.testNo),
      ('Fitness expiry', v.fitnessExpiry),
      ('Engine no.', v.engineNo),
      ('Chassis no.', v.chassisNo),
      ('Emission norms', v.emissionNorms),
      ('RTO', v.rtoDistrict),
      ('Contact', v.customerContact),
    ].where((r) => r.$2.trim().isNotEmpty).toList();

    if (rows.isEmpty) {
      return const AppCard(
        child: Text(
          'No additional details for this vehicle.',
          style: AppText.bodySecondary,
        ),
      );
    }

    return AppCard(
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Two columns on wide screens, one on phones.
          final twoColumns = constraints.maxWidth >= 520;
          final cells = [
            for (final r in rows) _InfoCell(label: r.$1, value: r.$2),
          ];
          if (!twoColumns) {
            return Column(
              children: [
                for (var i = 0; i < cells.length; i++) ...[
                  if (i > 0) const Divider(height: 1, indent: AppSpacing.card),
                  cells[i],
                ],
              ],
            );
          }
          return Column(
            children: [
              for (var i = 0; i < cells.length; i += 2) ...[
                if (i > 0) const Divider(height: 1, indent: AppSpacing.card),
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
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppText.chip.copyWith(fontSize: 14),
          ),
        ),
      ],
    ),
  );
}

// ── Phase header ────────────────────────────────────────────────────────────
class _PhaseHeader extends StatelessWidget {
  final String title, subtitle;
  final bool isDone;
  const _PhaseHeader({
    required this.title,
    required this.subtitle,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.md),
    child: Semantics(
      header: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title.toUpperCase(), style: AppText.overline),
                const SizedBox(height: 2),
                Text(subtitle, style: AppText.caption),
              ],
            ),
          ),
          if (isDone) ...[
            const SizedBox(width: AppSpacing.sm),
            const StatusBadge.pass(label: 'Done', dense: true),
          ],
        ],
      ),
    ),
  );
}

// ── Step card ───────────────────────────────────────────────────────────────
class _StepCard extends StatelessWidget {
  final int step;
  final IconData icon;
  final String title, subtitle;
  final int done, total;

  /// Non-null when the step can't be opened yet; shown on the card.
  final String? lockedReason;
  final VoidCallback onTap;

  const _StepCard({
    required this.step,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.done,
    required this.total,
    this.lockedReason,
    required this.onTap,
  });

  bool get _locked => lockedReason != null;
  bool get _complete => total > 0 && done >= total;

  @override
  Widget build(BuildContext context) {
    final Color tint = _locked
        ? na
        : _complete
        ? pass
        : appColor;
    final Color tintBg = _locked
        ? naLight
        : _complete
        ? passLight
        : accentLight;
    final progress = total > 0 ? (done / total).clamp(0.0, 1.0) : 0.0;

    final Widget badge = _locked
        ? const StatusBadge.neutral(
            label: 'Locked',
            icon: Icons.lock_outline_rounded,
            dense: true,
          )
        : _complete
        ? const StatusBadge.pass(label: 'Done', dense: true)
        : done > 0
        ? StatusBadge(
            label: '$done/$total',
            color: appColor,
            background: accentLight,
            dense: true,
          )
        : const StatusBadge.neutral(label: 'To do', dense: true);

    return Semantics(
      button: true,
      label:
          'Step $step, $title. ${lockedReason ?? (_complete ? 'Done' : '$done of $total')}',
      excludeSemantics: true,
      child: AppCard(
        onTap: onTap,
        borderColor: _complete ? pass.withValues(alpha: 0.35) : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: tintBg,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                _locked
                    ? Icons.lock_outline_rounded
                    : _complete
                    ? Icons.check_rounded
                    : icon,
                color: tint,
                size: AppIconSize.lg,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('STEP $step', style: AppText.overline),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.title.copyWith(
                      color: _locked ? textSecondary : textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lockedReason ?? subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption,
                  ),
                  if (!_locked && !_complete && total > 0) ...[
                    const SizedBox(height: AppSpacing.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 4,
                        backgroundColor: surface2,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          appColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                badge,
                const SizedBox(height: AppSpacing.sm),
                Icon(
                  Icons.chevron_right_rounded,
                  color: _locked ? textMuted : textSecondary,
                  size: AppIconSize.lg,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
