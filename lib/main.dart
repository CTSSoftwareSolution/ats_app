import 'package:ats_app/Presentation/provider/multiple_provider.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:overlay_support/overlay_support.dart';
import 'Core/network/services.dart';
import 'Presentation/provider/permission_provider.dart';
import 'Presentation/screens/splash_page/splash_screen.dart';


List<CameraDescription>? cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  final permissionProvider = PermissionProvider();
  await permissionProvider.checkAndRequestPermissions();
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
        navigatorKey: alice.getNavigatorKey(),
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        title: 'Flutter Demo',
        theme: ThemeData(
            scaffoldBackgroundColor: whiteColor,
            colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: false,
            appBarTheme: const AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: appColor, // Status bar color
                  statusBarIconBrightness:
                  Brightness.light, // Android icon color
                  statusBarBrightness: Brightness.light, // iOS icon color
                ))),
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: appColor,
            statusBarIconBrightness: Brightness.light,
          ),
          child: SplashScreen(),
        ),
      ),
    );
  }
}

