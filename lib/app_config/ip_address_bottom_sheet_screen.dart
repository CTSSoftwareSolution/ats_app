import 'package:ats_app/app_config/app_config.dart';
import 'package:ats_app/utilities/app_theme.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/validators.dart';
import 'package:flutter/material.dart';
import 'build_server_page.dart';



class IpAddressBottomSheetScreen extends StatefulWidget {
  const IpAddressBottomSheetScreen({super.key});

  @override
  State<IpAddressBottomSheetScreen> createState() => _IpAddressBottomSheetScreenState();
}

class _IpAddressBottomSheetScreenState extends State<IpAddressBottomSheetScreen> with SingleTickerProviderStateMixin {

  final formKey = GlobalKey<FormState>();
  late Animation<Offset> slideAnimation;
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  final TextEditingController mainIPController = TextEditingController();
  final TextEditingController secondaryIPController = TextEditingController();
  bool enableBackup = false;

  @override
  void initState(){
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );
    slideAnimation = Tween<Offset>(
      begin:  Offset(0, 0.1),
      end: Offset.zero
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic)
    );
    animationController.forward();

    mainIPController.text = appConfig.baseUrl;

    mainIPController.addListener((){
      setState(() {});
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    mainIPController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: Container(
              constraints: BoxConstraints(maxHeight: media.size.height * 0.9),
              decoration: const BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppRadius.xl),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: media.viewInsets.bottom + media.padding.bottom,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
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
                                        Text(
                                          "Server Configuration",
                                          style: AppText.sectionTitle,
                                        ),
                                        SizedBox(height: 2),
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
                                validator: (value){
                                  if ((value == null || value.isEmpty) &&
                                      (!enableBackup || secondaryIPController.text.isEmpty)) {
                                    return 'Please enter an IP address';
                                  }
                                  return null;
                                  },
                                suffixIcon: mainIPController.text.isNotEmpty
                                    ? IconButton(
                                  tooltip: "Clear",
                                  icon: const Icon(
                                    Icons.cancel_rounded,
                                    size: 20,
                                    color: textMuted,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      mainIPController.clear();
                                    });
                                  },
                                )
                                    : const Icon(
                                  Icons.lan_rounded,
                                  size: 20,
                                  color: textMuted,
                                ),
                              ),

                              Container(
                                decoration: BoxDecoration(
                                  color: bg,
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                  border: Border.all(color: border),
                                ),
                                child: SwitchListTile(
                                  activeThumbColor: appColor,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppRadius.md),
                                  ),
                                  title: const Text(
                                    "Enable Backup Server",
                                    style: AppText.title,
                                  ),
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
                                  suffixIcon: secondaryIPController.text.isNotEmpty
                                      ? IconButton(
                                    tooltip: "Clear",
                                    icon: const Icon(
                                      Icons.cancel_rounded,
                                      size: 20,
                                      color: textMuted,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        secondaryIPController.clear();
                                      });
                                    },
                                  )
                                      : const Icon(
                                    Icons.lan_rounded,
                                    size: 20,
                                    color: textMuted,
                                  ),
                                ),
                              ],

                              const SizedBox(height: AppSpacing.lg),
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                decoration: BoxDecoration(
                                  color: accentLight,
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline_rounded,
                                      color: appColor,
                                      size: 18,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "Changes will take effect immediately for all API requests",
                                        style: TextStyle(
                                          fontFamily: "Medium",
                                          fontSize: 12.5,
                                          color: appColor,
                                          height: 1.35,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed:
                                          () async {
                                        mainIPController.text=defaultBaseUrl;
                                        if (enableBackup) {
                                          secondaryIPController.clear();
                                        }
                                        appConfig.updateBaseUrl(context: context, newUrl: defaultBaseUrl);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
                                      ),
                                      child: const Text('Reset'),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    flex: 2,
                                    child: FilledButton.icon(
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {

                                          String newUrl = mainIPController.text.isNotEmpty
                                              ? mainIPController.text
                                              : (enableBackup && secondaryIPController.text.isNotEmpty
                                              ? secondaryIPController.text
                                              : defaultBaseUrl);

                                          await appConfig.updateBaseUrl(
                                            context: context,
                                            newUrl: newUrl,
                                          );
                                        }
                                      },
                                      style: FilledButton.styleFrom(
                                        minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
                                      ),
                                      icon: const Icon(Icons.save_rounded, size: 20),
                                      label: const Text('Save Address'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}

void showIpAddressBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    enableDrag: true,
    isDismissible: true,
    builder: (context) => const IpAddressBottomSheetScreen(),
    // builder: (context) => const IpAddressBottomSheet(),
  );
}
