
import 'package:ats_app/Presentation/screens/profile_page/profile_details_container.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_config/ip_address_bottom_sheet_screen.dart';
import '../../../utilities/app_theme.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';
import '../../../utilities/preferences.dart';
import '../../../widgets/custom_dialog_box.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: AppSpacing.page,
        title: const Text("Profile"),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.lg,
            AppSpacing.page,
            100,
          ),
          physics: const BouncingScrollPhysics(),
          children: [
            const ProfileDetailsContainer(),
            const SizedBox(height: AppSpacing.xl),
            const Padding(
              padding: EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.sm),
              child: Text("SETTINGS", style: AppText.overline),
            ),
            _ProfileMenuSection(
              children: List.generate(profileGridValues.length, (index) {
                final item = profileGridValues[index];
                return _ProfileMenuTile(
                  image: item.image,
                  icon: index == _ipConfigIndex ? Icons.settings_ethernet_rounded : null,
                  title: item.title,
                  subtitle: item.subtitle,
                  destructive: index == _logoutIndex,
                  onTap: () {
                    click(index, context);
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
          subTitle: 'Are you sure, you want to log out?',
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
                  const Divider(indent: 68, height: 1),
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
  final VoidCallback onTap;

  const _ProfileMenuTile({
    required this.image,
    this.icon,
    required this.title,
    required this.subtitle,
    required this.destructive,
    required this.onTap,
  });

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
                width: 40,
                height: 40,
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
                      Text(subtitle, style: AppText.caption.copyWith(color: textSecondary)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
