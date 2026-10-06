import 'package:ats_app/app_config/app_config.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/validators.dart';
import 'package:flutter/material.dart';
import '../utilities/new_app_theme/app_radius.dart';
import '../utilities/new_app_theme/app_spacing.dart';
import '../utilities/new_app_theme/app_text.dart';
import '../widgets/new_app_ui/app_bottom_sheet.dart';
import '../widgets/new_app_ui/primary_button.dart';
import '../widgets/new_app_ui/secondary_button.dart';
import 'build_server_page.dart';

class IpAddressBottomSheetScreen extends StatefulWidget {
  const IpAddressBottomSheetScreen({super.key});

  @override
  State<IpAddressBottomSheetScreen> createState() =>
      _IpAddressBottomSheetScreenState();
}

class _IpAddressBottomSheetScreenState
    extends State<IpAddressBottomSheetScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController mainIPController = TextEditingController();
  final TextEditingController secondaryIPController = TextEditingController();
  bool enableBackup = false;

  @override
  void initState() {
    super.initState();
    mainIPController.text = appConfig.baseUrl;

    mainIPController.addListener(_onFieldChanged);
    secondaryIPController.addListener(_onFieldChanged);
  }

  // Rebuilds so each field's clear button tracks whether it has text.
  void _onFieldChanged() => setState(() {});

  @override
  void dispose() {
    mainIPController.dispose();
    secondaryIPController.dispose();
    super.dispose();
  }

  Widget _fieldSuffix(TextEditingController controller) {
    if (controller.text.isEmpty) {
      return const Icon(Icons.lan_rounded, size: 20, color: textMuted);
    }
    return IconButton(
      tooltip: "Clear",
      icon: const Icon(Icons.cancel_rounded, size: 20, color: textMuted),
      onPressed: controller.clear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accentLight,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.router_rounded,
                    color: appColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Server Configuration", style: AppText.sectionTitle),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        "Configure your server IP address",
                        style: AppText.bodySecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            buildServerField(
              title: "Main Server IPv4 Address",
              controller: mainIPController,
              validator: (value) {
                if ((value == null || value.isEmpty) &&
                    (!enableBackup || secondaryIPController.text.isEmpty)) {
                  return 'Please enter an IP address';
                }
                return null;
              },
              suffixIcon: _fieldSuffix(mainIPController),
            ),

            // A Material (not a decorated Container) so the tile's ripple is
            // painted on the tinted background.
            Material(
              color: bg,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                side: const BorderSide(color: border),
              ),
              child: SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                title: const Text("Enable Backup Server", style: AppText.title),
                value: enableBackup,
                onChanged: (val) {
                  setState(() => enableBackup = val);
                },
              ),
            ),

            if (enableBackup) ...[
              const SizedBox(height: AppSpacing.lg),
              buildServerField(
                title: "Secondary Server IPv4 Address",
                controller: secondaryIPController,
                validator: (value) => Validators.validateIpAddress(value!),
                suffixIcon: _fieldSuffix(secondaryIPController),
              ),
            ],

            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: accentLight,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: appColor,
                    size: 18,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      "Changes will take effect immediately for all API requests",
                      style: AppText.caption.copyWith(color: appColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: 'Reset',
                    onPressed: () async {
                      mainIPController.text = defaultBaseUrl;
                      if (enableBackup) {
                        secondaryIPController.clear();
                      }
                      appConfig.updateBaseUrl(
                        context: context,
                        newUrl: defaultBaseUrl,
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        String newUrl = mainIPController.text.isNotEmpty
                            ? mainIPController.text
                            : (enableBackup &&
                                      secondaryIPController.text.isNotEmpty
                                  ? secondaryIPController.text
                                  : defaultBaseUrl);

                        await appConfig.updateBaseUrl(
                          context: context,
                          newUrl: newUrl,
                        );
                      }
                    },
                    icon: Icons.save_rounded,
                    label: 'Save Address',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showIpAddressBottomSheet(BuildContext context) {
  showAppBottomSheet(
    context: context,
    builder: (context) => const IpAddressBottomSheetScreen(),
    // builder: (context) => const IpAddressBottomSheet(),
  );
}
