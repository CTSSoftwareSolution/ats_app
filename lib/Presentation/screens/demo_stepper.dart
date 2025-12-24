// import 'package:ats_app/Presentation/screens/vehicle_test_parameter/upload_image_container.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../model/inspection_image_model.dart';
// import '../../utilities/color_data.dart';
// import '../../utilities/image_data.dart';
// import '../../utilities/media_picker_tiles.dart';
// import '../../widgets/custom_bottomsheet.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_stepper.dart';
// import '../../widgets/stepper_painter.dart';
// import '../../widgets/custom_text.dart';
// import '../provider/MediaPicker/file_provider.dart';
// import '../provider/vehicle_parts_provider.dart';
//
// class DemoStepper extends StatefulWidget {
//   const DemoStepper({super.key});
//
//   @override
//   State<DemoStepper> createState() => _DemoStepperState();
// }
//
// class _DemoStepperState extends State<DemoStepper> {
//   int currentStep = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchInspectionData();
//   }
//
//   Future<void> fetchInspectionData() async {
//
//     final detailsProvider = Provider.of<VehicleDetailsProvider>(context,listen: false);
//     await Future.delayed(const Duration(seconds: 1));
//
//     final response = [
//       {
//         "id": 1,
//         "title": "Upload Headlight Photo",
//         "subtitle": "Capture or upload the front headlight",
//         "isRequired": true,
//       },
//       {
//         "id": 2,
//         "title": "Upload Windscreen Photo",
//         "subtitle": "Capture or upload the front windscreen",
//         "isRequired": true,
//       },
//       {
//         "id": 3,
//         "title": "Upload Wing Mirrors Photo",
//         "subtitle": "Capture or upload the wing mirrors",
//         "isRequired": true,
//       },
//       {
//         "id": 4,
//         "title": "Upload Headlight Photo",
//         "subtitle": "Capture or upload the front headlight",
//         "isRequired": true,
//       },
//       {
//         "id": 5,
//         "title": "Upload Windscreen Photo",
//         "subtitle": "Capture or upload the front windscreen",
//         "isRequired": true,
//       },
//       {
//         "id": 6,
//         "title": "Upload Wing Mirrors Photo",
//         "subtitle": "Capture or upload the wing mirrors",
//         "isRequired": true,
//       },
//     ];
//
//     setState(() {
//       detailsProvider.inspectionList = response
//           .map((e) => InspectionImageModel.fromJson(e))
//           .toList();
//       detailsProvider.isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final fileProvider = Provider.of<FileProvider>(context);
//     final detailsProvider = Provider.of<VehicleDetailsProvider>(context);
//     final currentPageData = detailsProvider.getCurrentPageData();
//     final totalPages = (detailsProvider.inspectionList.length / detailsProvider.itemsPerPage).ceil();
//     return Scaffold(
//       appBar: AppBar(
//         titleSpacing: 0.0,
//         backgroundColor: appColor,
//         title: CustomText(
//           text: "Inspection-LMV",
//           fontSize: 22,
//           fontFamily: "SemiBold",
//           textColor: whiteColor,
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: ImageIcon(
//             AssetImage(backArrowIcon),
//             color: whiteColor,
//             size: 20,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
//           child: Column(
//             children: [
//               CustomStepper(totalStep: 8, currentStep: currentStep,),
//               Expanded(
//                 child: ListView.builder(
//                  // padding: EdgeInsets.symmetric(vertical: 100.0),
//                   itemCount: currentPageData.length,
//                   itemBuilder: (context, index) {
//                     final item = currentPageData[index];
//                     final imageFile = fileProvider.getImage(
//                       currentPageData[index].id,
//                     );
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 20.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           CustomText(
//                             text: item.title,
//                             fontFamily: "Bold",
//                             fontSize: 18.0,
//                           ),
//                           CustomText(
//                             text: item.subtitle,
//                             fontFamily: "Medium",
//                             fontSize: 15.0,
//                           ),
//                           SizedBox(height: 10.0),
//                           UploadImageContainer(
//                             onTap: () {
//                               customBottomSheet(
//                                 context: context,
//                                 title: "Select Media",
//                                 child: mediaPickerTiles(
//                                   context: context,
//                                   inspectionId: item.id,
//                                 ),
//                               );
//                             },
//                             inspectionId: item.id,
//                           ),
//                           imageFile != null
//                               ? Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 5.0),
//                             child: CustomButton(
//                               height: 38,
//                               width: double.infinity,
//                               buttonText: "Re-upload",
//                               onPress: () {
//                                 customBottomSheet(
//                                   context: context,
//                                   title: "Select Media",
//                                   child: mediaPickerTiles(
//                                     context: context,
//                                     inspectionId: item.id,
//                                   ),
//                                 );
//                               },
//                               backgroundColor: appColor,
//                               foregroundColor: whiteColor,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.all(Radius.circular(5.0))
//                               ),
//                               fontSize: 15,
//                               fontFamily: "Bold",
//                             ),
//                           )
//                               : SizedBox.shrink(),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//
//               Padding(
//                 padding: const EdgeInsets.only(top: 10.0),
//                 child: CustomButton(
//                   width: double.infinity,
//                   height: 50.0,
//                   buttonText: "Next",
//                   onPress: () {
//                     if(currentStep < totalPages){
//                       setState(() {
//                         currentStep++;
//                       });
//                     }
//                     if (detailsProvider.currentPage < totalPages - 1) {
//                       setState(() {
//                         detailsProvider.currentPage++;
//                       });
//                     } else {
//                       final images = fileProvider.allUploadedData;
//
//                       for (var img in images) {
//                         print(img.name);
//                       }
//                       const snack = SnackBar(content: Text("All images completed"),duration: Duration(seconds: 3),);
//                       ScaffoldMessenger.of(context).showSnackBar(snack);
//                       print("All inspection images completed");
//                     }
//                   },
//                   backgroundColor: appColor,
//                   foregroundColor: whiteColor,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadiusGeometry.all(
//                       Radius.circular(30.0),
//                     ),
//                   ),
//                   fontSize: 20.0,
//                   fontFamily: "Bold",
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
