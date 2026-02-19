import 'package:ats_app/app_config/app_config.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/extension.dart';
import 'package:ats_app/utilities/input_formatters.dart';
import 'package:ats_app/utilities/validators.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:ats_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
    return AnimatedBuilder(
      animation: animationController,
      builder: (context,child) {
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [

                    Colors.blue[50]!,
                    Colors.white,
                    Colors.white,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        child: Column(
                          children: [
                            Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    appColor.withOpacity(0.55),
                                    appColor.withOpacity(0.65),
                                    // Colors.blue[300]!,
                                    // Colors.blue[400]!,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Container(
                              width: 28,
                              height: 3,
                              decoration: BoxDecoration(
                                color: appColor.withOpacity(0.45),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      appColor.withOpacity(0.85),
                                      appColor.withOpacity(0.95),
                                      appColor,
                                      // Colors.blue[600]!,
                                      // Colors.blue[700]!,
                                      // Colors.blue[800]!,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                      spreadRadius: 1,
                                    )
                                  ]
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: cardBackgroundColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: cardBackgroundColor,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Icon(Icons.router_rounded,color: Colors.white,size: 24,),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: "Server Configuration",
                                          fontSize: 18.0,
                                          fontFamily: "Bold",
                                          textColor: whiteColor,
                                        ),
                                        SizedBox(height: 2),
                                        CustomText(text: "Configure your server IP address",
                                        fontSize: 12, textColor: whiteColor,fontFamily: "Medium",)
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              buildServerField(
                                title: "Main Server IPv4 Address",
                                controller: mainIPController,
                                suffixIcon: mainIPController.text.isNotEmpty
                                    ? IconButton(
                                  icon: Icon(
                                    Icons.cancel_rounded,
                                    size: 20,
                                    color: Colors.grey[400],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      mainIPController.clear();
                                    });
                                  },
                                )
                                    : Icon(
                                  Icons.lan_rounded,
                                  size: 20,
                                  color: Colors.grey[300],
                                ),
                              ),

                              SwitchListTile(
                                activeThumbColor: appColor,
                                title: const Text("Enable Backup Server"),
                                value: enableBackup,
                                onChanged: (val) {
                                  setState(() => enableBackup = val);
                                },
                              ),

                              if (enableBackup)
                                buildServerField(
                                  title: "Secondary Server IPv4 Address",
                                  controller: secondaryIPController,
                                  suffixIcon: secondaryIPController.text.isNotEmpty
                                      ? IconButton(
                                    icon: Icon(
                                      Icons.cancel_rounded,
                                      size: 20,
                                      color: Colors.grey[400],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        secondaryIPController.clear();
                                      });
                                    },
                                  )
                                      : Icon(
                                    Icons.lan_rounded,
                                    size: 20,
                                    color: Colors.grey[300],
                                  ),
                                ),

                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                          colors: [
                                            appColor.withOpacity(0.85),
                                            appColor.withOpacity(0.95),
                                            appColor,
                                            // Colors.blue[500]!,
                                            // Colors.blue[600]!,
                                            // Colors.blue[700]!,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: appColor.withOpacity(0.4),
                                           // color: Colors.blue.withOpacity(0.4),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        //onPressed:
                                        //     () async {
                                        //   mainIPController.text=defaultBaseUrl;
                                        //   if (enableBackup) {
                                        //     secondaryIPController.clear();
                                        //   }
                                        //   appConfig.updateBaseUrl(context: context, newUrl: defaultBaseUrl,
                                        //     secondaryUrl: enableBackup ? secondaryIPController.text : null);
                                        // },
                                        onPressed: () async {
                                          setState(() {
                                            enableBackup = false;
                                            mainIPController.text = defaultBaseUrl;
                                            secondaryIPController.clear();
                                          });

                                          await appConfig.updateBaseUrl(
                                            context: context,
                                            newUrl: defaultBaseUrl,
                                            secondaryUrl: null,
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          foregroundColor:whiteColor,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          'Reset',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  20.width,
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                          colors: [
                                            appColor.withOpacity(0.85),
                                            appColor.withOpacity(0.95),
                                            appColor,
                                            // Colors.blue[500]!,
                                            // Colors.blue[600]!,
                                            // Colors.blue[700]!,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: appColor.withOpacity(0.4),
                                           // color: Colors.blue.withOpacity(0.4),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if(formKey.currentState!.validate()){
                                            appConfig.updateBaseUrl(
                                                context: context,
                                                newUrl: mainIPController.text,
                                                secondaryUrl:  enableBackup ? secondaryIPController.text : null);
                                          }

                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          foregroundColor: whiteColor,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.save_rounded, size: 18),
                                            SizedBox(width: 8),
                                            Text(
                                              'Save Address',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      cardBackgroundColor,
                                      appColor.withOpacity(0.08),
                                      // Colors.blue[50]!,
                                      // Colors.blue[100]!.withOpacity(0.3),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: appColor.withOpacity(0.3),
                                   // color: Colors.blue[200]!,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline_rounded,
                                      color: appColor,
                                      // color: Colors.blue[700],
                                      size: 18,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: CustomText(text: "Changes will take effect immediately for all API requests",
                                      fontSize: 11.0, textColor: Colors.blue[900],fontFamily: "Medium",),
                                    )
                                  ],
                                ),
                              )
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
