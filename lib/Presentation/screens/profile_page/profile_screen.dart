import 'package:ats_app/Presentation/screens/profile_page/profile_details_container.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:ats_app/widgets/new_app_ui/app_top_bar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../../app_config/ip_address_bottom_sheet_screen.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';
import '../../../utilities/new_app_theme/app_radius.dart';
import '../../../utilities/new_app_theme/app_spacing.dart';
import '../../../utilities/new_app_theme/app_text.dart';
import '../../../utilities/preferences.dart';
import '../../../widgets/custom_dialog_box.dart';
import '../../../widgets/new_app_ui/section_header.dart';
import '../../provider/create_queue_provider.dart';
import '../../provider/login_provider.dart';

import '../login_page/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  /// Index of the "Logout" entry in [profileGridValues] (see [click]).
  static const int _logoutIndex = 5;

  /// Index of the "Ip Config" entry in [profileGridValues] (see [click]).
  static const int _ipConfigIndex = 4;

  /// Index of the "Version" entry in [profileGridValues].
  static const int _versionIndex = 6;

  /// Entries that [click] actually handles; the others are shown as plain
  /// information rows so they don't look tappable.
  static const Set<int> _actionIndexes = {_ipConfigIndex, _logoutIndex};

  late final Future<PackageInfo> _packageInfo = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: const AppTopBar(title: "Profile"),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.lg,
            AppSpacing.page,
            AppSpacing.xl,
          ),
          physics: const BouncingScrollPhysics(),
          children: [
            const ProfileDetailsContainer(),
            const SizedBox(height: AppSpacing.xl),
            const SectionHeader(
              "Settings",
              padding: EdgeInsets.only(
                left: AppSpacing.xs,
                bottom: AppSpacing.sm,
              ),
            ),
            _ProfileMenuSection(
              children: List.generate(profileGridValues.length, (index) {
                final item = profileGridValues[index];
                final isAction = _actionIndexes.contains(index);
                final tile = _ProfileMenuTile(
                  image: item.image,
                  icon: index == _ipConfigIndex
                      ? Icons.settings_ethernet_rounded
                      : null,
                  title: item.title,
                  subtitle: item.subtitle,
                  destructive: index == _logoutIndex,
                  showChevron: index == _ipConfigIndex,
                  onTap: isAction
                      ? () {
                          click(index, context);
                        }
                      : null,
                );
                if (index != _versionIndex) return tile;
                return FutureBuilder<PackageInfo>(
                  future: _packageInfo,
                  builder: (context, snapshot) {
                    final info = snapshot.data;
                    if (info == null) return tile;
                    return tile.copyWithSubtitle(
                      'Version ${info.version} (${info.buildNumber})',
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void click(int index, BuildContext context) {
    switch (index) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        showIpAddressBottomSheet(context);
        break;
      case 5:
        customShowDialog(
          context: context,
          title: "Log out",
          subTitle: 'Are you sure you want to log out?',
          cancelLabel: "Cancel",
          confirmLabel: "Log out",
          icon: Icons.logout_rounded,
          destructive: true,
          cancelClick: () {
            context.pop(context);
          },
          okClick: () {
            Preferences.clear();
            context.read<CreateQueueProvider>().clearUploadedImages();
            context.read<LoginProvider>().emailController.clear();
            context.read<LoginProvider>().passwordController.clear();
            context.push(LoginScreen());
          },
        );
        break;
      case 6:
        break;
      default:
        break;
    }
  }
}

/// Flat white group with hairline dividers between its tiles.
class _ProfileMenuSection extends StatelessWidget {
  final List<Widget> children;

  const _ProfileMenuSection({required this.children});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.lg);
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: radius,
        border: Border.all(color: border),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Material(
          color: Colors.transparent,
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  const Divider(indent: _ProfileMenuTile.textInset, height: 1),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  final String image;
  final IconData? icon;
  final String title;
  final String subtitle;
  final bool destructive;
  final bool showChevron;

  /// Null for information-only rows: no ripple and not announced as a button.
  final VoidCallback? onTap;

  static const double _iconBox = 40;

  /// Horizontal offset of the title text, used to align the dividers with it.
  static const double textInset = AppSpacing.lg + _iconBox + AppSpacing.md;

  const _ProfileMenuTile({
    required this.image,
    this.icon,
    required this.title,
    required this.subtitle,
    required this.destructive,
    this.showChevron = false,
    required this.onTap,
  });

  _ProfileMenuTile copyWithSubtitle(String newSubtitle) => _ProfileMenuTile(
    image: image,
    icon: icon,
    title: title,
    subtitle: newSubtitle,
    destructive: destructive,
    showChevron: showChevron,
    onTap: onTap,
  );

  @override
  Widget build(BuildContext context) {
    final Color tint = destructive ? fail : appColor;
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 64),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Container(
                width: _iconBox,
                height: _iconBox,
                decoration: BoxDecoration(
                  color: destructive ? failLight : accentLight,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                alignment: Alignment.center,
                child: icon != null
                    ? Icon(icon, size: 20, color: tint)
                    : Image(
                        image: AssetImage(image),
                        width: 20,
                        height: 20,
                        color: tint,
                      ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppText.title.copyWith(
                        color: destructive ? fail : textPrimary,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppText.caption.copyWith(color: textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
              if (showChevron) ...[
                const SizedBox(width: AppSpacing.sm),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: textSecondary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
