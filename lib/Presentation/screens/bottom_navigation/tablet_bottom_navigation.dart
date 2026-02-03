import 'package:ats_app/Presentation/provider/login_provider.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/color_data.dart';
import '../../../utilities/image_data.dart';
import '../../../utilities/preferences.dart';
import '../../../widgets/custom_dialog_box.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/widget_navigation_icon.dart';
import '../login_page/login_screen.dart';

class TabletBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const TabletBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
      child: Container(
        width: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            colors: [Color(0xff345afa), Color(0xff19162e)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomImage(image: logoImage,height: 28.0,width: 28.0,),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: bottomNavValue.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: navigationIcon(
                      bottomNavValue[index].image,
                      bottomNavValue[index].id,
                      bottomNavValue[index].title,
                      currentIndex,
                      onTabSelected,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: InkWell(
                onTap: (){
                  customShowDialog(
                    context: context,
                    title: "Log out",
                    subTitle: 'Are you sure, you want to log out?',
                    cancelClick: () {
                      context.pop(context);
                    },
                    okClick: () {
                      Preferences.clear();
                      context.read<LoginProvider>().emailController.clear();
                      context.read<LoginProvider>().passwordController.clear();
                      context.push(LoginScreen());
                    },
                  );
                },
                child: CustomImage(
                  image: logoutIcon,height: 25.0,width: 25.0,color: whiteColor,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
