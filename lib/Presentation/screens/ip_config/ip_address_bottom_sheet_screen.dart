import 'package:ats_app/Presentation/screens/ip_config/config_provider.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:ats_app/utilities/input_formatters.dart';
import 'package:ats_app/utilities/validators.dart';
import 'package:ats_app/widgets/custom_text.dart';
import 'package:ats_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class IpAddressBottomSheetScreen extends StatefulWidget {
  const IpAddressBottomSheetScreen({super.key});

  @override
  State<IpAddressBottomSheetScreen> createState() => _IpAddressBottomSheetScreenState();
}

class _IpAddressBottomSheetScreenState extends State<IpAddressBottomSheetScreen> with SingleTickerProviderStateMixin {



  @override
  void initState(){
    super.initState();
    final configProvider = Provider.of<ConfigProvider>(context, listen: false);
    configProvider.loadCurrentIp(context);

    configProvider.animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    configProvider.fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: configProvider.animationController, curve: Curves.easeOut),
    );

    configProvider.slideAnimation = Tween<Offset>(
      begin:  Offset(0, 0.1),
      end: Offset.zero
    ).animate(
      CurvedAnimation(parent: configProvider.animationController, curve: Curves.easeOutCubic)
    );

    configProvider.animationController.forward();

    configProvider.ipController.addListener((){
      setState(() {});
    });

  }





  @override
  Widget build(BuildContext context) {
    final configProvider = context.watch<ConfigProvider>();
    return AnimatedBuilder(
      animation: configProvider.animationController,
      builder: (context,child) {
        return FadeTransition(
          opacity: configProvider.fadeAnimation,
          child: SlideTransition(
            position: configProvider.slideAnimation,
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
                                    Colors.blue[300]!,
                                    Colors.blue[400]!,
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
                                color: Colors.blue[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                        child: Form(
                          key: configProvider.formKey,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.blue[600]!,
                                      Colors.blue[700]!,
                                      Colors.blue[800]!,
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
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.3),
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
                                          letterSpacing: -0.3,
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
                              Row(
                                children: [
                                  Icon(
                                    Icons.storage_rounded,
                                    size: 16,
                                    color: Colors.blue[700],
                                  ),
                                  const SizedBox(width: 6),
                                  CustomText(text: "Server IP Address", fontSize: 13,
                                  textColor: Colors.grey[800],letterSpacing: 0.3,fontFamily: "Bold",)
                                ],
                              ),
                              const SizedBox(height: 10),

                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.06),
                                      blurRadius: 12,
                                      offset: const Offset(0, 3),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: CustomTextField(
                                    controller: configProvider.ipController,
                                    validator: (value) => Validators.validateIpAddress(value!),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: InputFormatters.ipAddressFormat,
                                    hint: "192.168.1.100:8080",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Medium',
                                    ),
                                    prefixIcon: Container(
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.blue[400]!,
                                            Colors.blue[600]!,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blue.withOpacity(0.25),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.settings_ethernet_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                    suffixIcon: configProvider.ipController.text.isNotEmpty
                                        ? IconButton(
                                      icon: Icon(
                                        Icons.cancel_rounded,
                                        size: 20,
                                        color: Colors.grey[400],
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          configProvider.ipController.clear();
                                        });
                                      },
                                    )
                                        : Icon(
                                      Icons.lan_rounded,
                                      size: 20,
                                      color: Colors.grey[300],
                                    ),

                                    fillColor: Colors.white,
                                    readOnly: false,
                                    textCapitalization: TextCapitalization.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber[50],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.amber[200]!,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline_rounded,
                                      color: Colors.amber[700],
                                      size: 16,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Format: IP:PORT (e.g., 192.168.1.1:8080)',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.amber[900],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      colors: configProvider.isLoading
                                          ? [Colors.blue[300]!, Colors.blue[400]!]
                                          : [
                                        Colors.blue[500]!,
                                        Colors.blue[600]!,
                                        Colors.blue[700]!,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.4),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: configProvider.isLoading
                                        ? null
                                        : () async {
                                      await configProvider.saveIpAddress(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: configProvider.isLoading
                                        ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                        : const Row(
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
