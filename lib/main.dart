import 'package:ats_app/Presentation/provider/multiple_provider.dart';
import 'package:ats_app/utilities/new_app_theme/app_theme.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:overlay_support/overlay_support.dart';
import 'Core/network/services.dart';
import 'Presentation/provider/permission_provider.dart';
import 'Presentation/screens/splash_page/splash_screen.dart';
import 'app_config/app_config.dart';


List<CameraDescription>? cameras;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appConfig.load();
  cameras = await availableCameras();
  final permissionProvider = PermissionProvider();
  await permissionProvider.checkAndRequestPermissions();
  AppTheme.configureLoader();
  runApp(MultipleProvider(permissionProvider: permissionProvider));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        title: 'ATS',
        theme: AppTheme.light,
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: AppTheme.statusBarStyle,
          child: SplashScreen(),
        ),
      ),
    );
  }
}

