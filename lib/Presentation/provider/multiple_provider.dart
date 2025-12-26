


import 'package:ats_app/Data/repositories_impl/login_repo_impl.dart';
import 'package:ats_app/Data/repositories_impl/profile_details_repo_impl.dart';
import 'package:ats_app/Data/repositories_impl/slider_repo_impl.dart';
import 'package:ats_app/Data/repositories_impl/vehicle_class_repo_impl.dart';
import 'package:ats_app/Data/repositories_impl/vehicle_parts_repo_impl.dart';
import 'package:ats_app/Data/repositories_impl/vehicle_type_repo_impl.dart';
import 'package:ats_app/Domain/usecases/login_usecases.dart';
import 'package:ats_app/Domain/usecases/profile_details_usecases.dart';
import 'package:ats_app/Domain/usecases/slider_usecases.dart';
import 'package:ats_app/Domain/usecases/vehicle_parts_usecases.dart';
import 'package:ats_app/Domain/usecases/vehicle_type_usecases.dart';
import 'package:ats_app/Presentation/provider/inspection_result_provider.dart';
import 'package:ats_app/Presentation/provider/login_provider.dart';
import 'package:ats_app/Presentation/provider/permission_provider.dart';
import 'package:ats_app/Presentation/provider/profile_details_provider.dart';
import 'package:ats_app/Presentation/provider/slider_provider.dart';
import 'package:ats_app/Presentation/provider/splash_provider.dart';
import 'package:ats_app/Presentation/provider/vehicle_class_provider.dart';
import 'package:ats_app/Presentation/provider/vehicle_parts_provider.dart';
import 'package:ats_app/Presentation/provider/vehicle_type_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Domain/usecases/vehicle_class_usecases.dart';
import '../../main.dart';
import 'MediaPicker/file_provider.dart';
import 'bottom_navigation_provider.dart';

class MultipleProvider extends StatelessWidget {
  final PermissionProvider permissionProvider;
  const MultipleProvider({super.key, required this.permissionProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => permissionProvider),
        ChangeNotifierProvider(create: (_) => BottomNavigationProvider()),
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider(loginUseCases: LoginUseCases(loginRepository: LoginRepoImpl()))),
        ChangeNotifierProvider(create: (_) => FileProvider()),
        ChangeNotifierProvider(create: (_) => VehiclePartsProvider(vehiclePartsUseCases: VehiclePartsUseCases(vehiclePartsRepository: VehiclePartsRepoImpl()))),
        ChangeNotifierProvider(create: (_) => VehicleTypeProvider(vehicleTypeUseCases: VehicleTypeUseCases(vehicleTypeRepository: VehicleTypeRepoImpl()))),
        ChangeNotifierProvider(create: (_) => VehicleClassProvider(vehicleClassUseCases: VehicleClassUseCases(vehicleClassRepository: VehicleClassRepoImpl()))),
        ChangeNotifierProvider(create: (_) => SliderProvider(sliderUseCases: SliderUseCases(sliderRepository: SliderRepoImpl()))),
        ChangeNotifierProvider(create: (_) => ProfileDetailsProvider(profileDetailsUseCases: ProfileDetailsUseCases(profileDetailsRepository: ProfileDetailsRepoImpl()))),
        ChangeNotifierProvider(create: (_) => InspectionResultProvider())
      ],
      child: const MyApp(),
    );
  }
}
