import 'package:ats_app/Presentation/provider/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utilities/custom_progress_indicator.dart';
import '../../../utilities/logo_screen_item.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    final splashProvider = Provider.of<SplashProvider>(context,listen: false);
    splashProvider.startTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Color(0xff345afa), Color(0xff19162e)
            ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: Column(
              children: [
                Expanded(child: LogoScreenItem()),
                CustomProgressIndicator(),
                SizedBox(height: 100.0,)
              ],
            )
        ),
      ),
    );
  }
}
