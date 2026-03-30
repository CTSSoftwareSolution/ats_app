import 'package:ats_app/Data/repositories_impl/lane_list_impl.dart';
import 'package:ats_app/Data/repositories_impl/login_repo_impl.dart';
import 'package:ats_app/Data/repositories_impl/manual_inspection_list_impl.dart';
import 'package:ats_app/Data/repositories_impl/pre_save_inspection_impl.dart';
import 'package:ats_app/Data/repositories_impl/vehicle_class_repo_impl.dart';
import 'package:ats_app/Data/repositories_impl/vehicle_parts_repo_impl.dart';
import 'package:ats_app/Domain/repositories/manual_inspection_repository.dart';
import 'package:ats_app/Domain/repositories/vehicle_parts_repository.dart';
import 'package:ats_app/Domain/usecases/lane_list_usecase.dart';
import 'package:ats_app/Domain/usecases/login_usecases.dart';
import 'package:ats_app/Domain/usecases/manual_inspection_list_usecase.dart';
import 'package:ats_app/Domain/usecases/pre_inspection_result_usecases.dart';
import 'package:ats_app/Domain/usecases/pre_save_inspection_usecase.dart';
import 'package:ats_app/Domain/usecases/vehicle_parts_usecases.dart';
import 'package:ats_app/Presentation/provider/inspection_form_provider.dart';
import 'package:ats_app/Presentation/provider/inspection_result_provider.dart';
import 'package:ats_app/Presentation/provider/login_provider.dart';
import 'package:ats_app/Presentation/provider/permission_provider.dart';
import 'package:ats_app/Presentation/provider/pre_inspection_result_provider.dart';
import 'package:ats_app/Presentation/provider/splash_provider.dart';
import 'package:ats_app/Presentation/provider/vehicle_class_provider.dart';
import 'package:ats_app/Presentation/provider/vehicle_parts_provider.dart';
import 'package:ats_app/Presentation/provider/verify_hsrp_provider.dart';
import 'package:ats_app/Presentation/screens/manual_inspection_images/manual_ins_image_provider.dart';
import 'package:ats_app/aws_images/aws_repository_impl.dart';
import 'package:ats_app/aws_images/aws_signedurl_provider.dart';
import 'package:ats_app/aws_images/aws_usecase.dart';
import 'package:ats_app/location/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Data/repositories_impl/document_manual_doc_impl.dart';
import '../../Data/repositories_impl/inspection_que_impl.dart';
import '../../Domain/repositories/pre_inspection_result_repository.dart';
import '../../Domain/usecases/document_manual_doc_usecase.dart';
import '../../Domain/usecases/inspection_que_usecases.dart';
import '../../Domain/usecases/vehicle_class_usecases.dart';
import '../../image_processing/MediaPicker/file_provider.dart';
import '../../main.dart';
import '../screens/pre_inspection_form/pre_save_inspection_provider.dart';
import 'bottom_navigation_provider.dart';
import 'lane_list_provider.dart';
import 'manual_inspection_list_provider.dart';

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
        ChangeNotifierProvider(create: (_) => VerifyHRSPProvider()),
        ChangeNotifierProvider(create: (_) => ManualInspectionListProvider(manualInspectionListUseCase: ManualInspectionListUseCase(manualInspectionRepository: ManualInspectionListImpl()))),
        ChangeNotifierProvider(create: (_) => LoginProvider(loginUseCases: LoginUseCases(loginRepository: LoginRepoImpl()))),
        ChangeNotifierProvider(create: (_) => FileProvider()..initCamera()),
        ChangeNotifierProvider(create: (_) => VehicleClassProvider(vehicleClassUseCases: VehicleClassUseCases(vehicleClassRepository: VehicleClassRepoImpl()))),
        ChangeNotifierProvider(create: (_) => InspectionResultProvider()),
        ChangeNotifierProvider(create: (_) => InspectionFormProvider(inspectionQueUseCases: InspectionQueUseCases(inspectionQueRepository: InspectionQueImpl()))),
        ChangeNotifierProvider(create: (_) => AwsSignedUrlProvider(awsUseCase: AwsUseCase(repository: AwsRepositoryImpl()))),
        ChangeNotifierProvider(create: (_) => ManualInsImageProvider(useCase: DocumentManualDocUseCase(repository: DocumentManualDocImpl()))),
        ChangeNotifierProvider(create: (_) => PreSaveInspectionProvider(useCase: PreSaveInspectionUseCase(repository: PreSaveInspectionImpl()))),
       // ChangeNotifierProvider(create: (_) => PreInspectionResultProvider(preInspectionResultUseCases: PreInspectionResultUseCases(preInspectionResultRepository:))),
        ChangeNotifierProvider(create: (_) => LaneListProvider(laneListUseCase: LaneListUseCase(laneListRepository: LaneListImpl()))),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => VehiclePartsProvider(vehiclePartsUseCases: VehiclePartsUseCases(vehiclePartsRepository: VehiclePartsRepoImpl())))
      ],
      child: const MyApp(),
    );
  }
}
