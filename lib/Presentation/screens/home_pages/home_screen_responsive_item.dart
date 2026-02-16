import 'package:ats_app/Presentation/provider/config_provider.dart';
import 'package:ats_app/Presentation/screens/home_pages/select_vehicle.dart';
import 'package:ats_app/utilities/input_formatters.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:ats_app/utilities/validators.dart';
import 'package:ats_app/widgets/custom_bottomsheet.dart';
import 'package:ats_app/widgets/custom_button.dart';
import 'package:ats_app/widgets/custom_text_field.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utilities/color_data.dart';
import '../../../utilities/extension.dart';
import '../../../utilities/image_data.dart';
import '../../../utilities/ip_address_bottom_sheet.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_text.dart';
import 'image_slider.dart';

class HomeScreenResponsiveItem extends StatefulWidget {
  const HomeScreenResponsiveItem({super.key});

  @override
  State<HomeScreenResponsiveItem> createState() => _HomeScreenResponsiveItemState();
}

class _HomeScreenResponsiveItemState extends State<HomeScreenResponsiveItem> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final configProvider = context.watch<ConfigProvider>();
    final isTablet = MediaQuery.of(context).size.width >= 600;
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 40.0),
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: isTablet ? 50.0 : 30.0,horizontal: isTablet ? 20.0 : 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            isTablet ?
            CustomText(text: "ATS Corporation", fontSize: isTablet ? 34.0 : 24.0, fontFamily: "Black") :
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomImage(image: logoImage,height: 28.0,width: 28.0,),
                    15.width,
                    CustomText(text: "ATS Corporation", fontSize: 24.0, fontFamily: "Black",)
                  ],
                ),
                InkWell(
                  onTap: (){

                    customBottomSheet(
                        context: context, title: "Title",
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [

                                    CustomTextField(
                                      contentPadding: EdgeInsets.only(  left: 10.0),
                                      inputFormatters: InputFormatters.ipAddressValidation,
                                      validator: (value) => Validators.validateIp(value!),
                                      fillColor: whiteColor,
                                        hint: "Enter IP Address",
                                        controller: configProvider.controller,
                                        hintStyle: TextStyle(),
                                        readOnly: false,
                                        keyboardType: TextInputType.number,
                                        textCapitalization: TextCapitalization.words),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                                      child: CustomButton(
                                        width: double.infinity,
                                          height: 40.0,
                                          buttonText: "Submit",
                                          onPress: () async{
                                          if(formKey.currentState!.validate()){
                                            await Preferences.setPreferences();
                                            await Preferences.setIpAddress(configProvider.controller.text);
                                            context.pop();
                                          }
                                            },
                                          backgroundColor: appColor, foregroundColor: whiteColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(30.0))
                                          ), fontSize: 18.0,
                                        fontFamily: "Bold",
                                      ),
                                    )
                                  ],
                                ),
                              )
                    );
                  },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        color: appColor
                      ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomImage(image: configIcon,scale: 22,color: whiteColor,),
                        )))
              ],
            ),
            isTablet ? 20.height :25.height,
            ImageSlider(),
            isTablet ? 35.height :30.height,
            SelectVehicle(),
            isTablet ? 70.height :60.height,
            CustomText(text: "Scan, Detect", fontFamily: "Heavy", fontSize:  isTablet ? 56.0 : 46.0,textColor: scanTextColor,),
            Row(
              children: [
                CustomText(text: "Drive Safe", fontFamily: "Heavy", fontSize:  isTablet ? 56.0 :46.0,textColor: scanTextColor,),
                10.width,
                CustomImage(image: heartIcon,scale:  isTablet ? 2.5 : 4),
              ],
            ),
            20.height,
            CustomImage(scale: isTablet ? 2.5 : 4, image: dividerImage,),
            20.height,
            Row(
              children: [
                CustomImage(image: logoImage,height: 18.0,width: 18.0,),
                10.width,
                CustomText(text: "ATS Corporation", fontSize: 15.0, fontFamily: "Black",)
              ],
            ),
            40.height
          ],
        ),
      ),
    );
  }
}
