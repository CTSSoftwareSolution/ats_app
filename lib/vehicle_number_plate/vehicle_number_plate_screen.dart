import 'dart:io';

import 'package:ats_app/Presentation/screens/camera_page/camera_screen.dart';
import 'package:camera/camera.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Presentation/provider/verify_hsrp_provider.dart';
import '../Presentation/screens/vehicle_number_plate/vehicle_number_plate_models.dart';
import '../Presentation/screens/vehicle_test_parameter/upload_image_container.dart';
import '../image_processing/MediaPicker/file_provider.dart';
import '../utilities/color_data.dart';
import '../utilities/extension.dart';
import '../widgets/custom_text.dart';

class VehicleNumberPlateScreen extends StatefulWidget {
  const VehicleNumberPlateScreen({super.key});

  @override
  State<VehicleNumberPlateScreen> createState() =>
      _VehicleNumberPlateScreenState();
}

class _VehicleNumberPlateScreenState extends State<VehicleNumberPlateScreen> {
  static const int _frontIndex = 0;

  final TextEditingController _frontController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VerifyHRSPProvider>().clearData();
      context.read<FileProvider>().clearImages();
      _frontController.clear();
    });
  }

  @override
  void dispose() {
    _frontController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileProvider = context.watch<FileProvider>();
    final verifyProvider = context.watch<VerifyHRSPProvider>();

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appColor,
        title: const Text("Detect number plate"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                text: "Expected Plate Number",
                fontSize: 16,
                fontFamily: "SemiBold",
              ),

              8.height,

              TextField(
                controller: _frontController,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: "e.g. MH40BE2665",
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: appColor, width: 1.5),
                  ),
                ),
              ),

              20.height,

              const CustomText(
                text: "Capture Front Registration Plate",
                fontSize: 16,
                fontFamily: "SemiBold",
              ),

              10.height,

              UploadImageContainer(
                isVideo: false,
                width: double.infinity,
                index: _frontIndex,
                isTablet: false,
                onTap: () =>
                    _openCameraAndVerify(context, fileProvider, verifyProvider),
              ),

              20.height,

              /// Loading
              if (verifyProvider.isLoading) const _LoadingResult(),

              /// Result
              if (!verifyProvider.isLoading &&
                  verifyProvider.vehicleResponse?.analysis != null)
                _VerificationResult(
                  response: verifyProvider.vehicleResponse!,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openCameraAndVerify(
      BuildContext context,
      FileProvider fileProvider,
      VerifyHRSPProvider verifyProvider,
      ) async {
    final expectedPlate = _frontController.text.trim();

    if (expectedPlate.isEmpty) {
      context.showErrorSnackBar("Please enter expected plate number");
      return;
    }

    fileProvider.setCurrentIndex(_frontIndex);

    await fileProvider.initCamera();

    if (!context.mounted) return;

    await context.push(CameraScreen());

    if (!context.mounted) return;

    final XFile? xFile = fileProvider.getImage(_frontIndex);

    if (xFile == null) return;

    await verifyProvider.verifyPlate(
      imageFile: File(xFile.path),
      expectedPlate: expectedPlate, context: context,
    );

    if (!context.mounted) return;

    if (verifyProvider.error != null) {
      context.showErrorSnackBar(verifyProvider.error!);
    }
  }
}

class _LoadingResult extends StatelessWidget {
  const _LoadingResult();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _VerificationResult extends StatelessWidget {
  const _VerificationResult({required this.response});

  final VehicleNumberPlateModels response;

  @override
  Widget build(BuildContext context) {
    final analysis = response.analysis;

    final decision = analysis?.decision ?? "UNKNOWN";
    final plate = analysis?.ocrPlateText ?? "-";
    final reason = analysis?.reason ?? "No reason";
    final expectedPlate = analysis?.expectedPlate ?? "-";

    final bool isApproved = decision == "ACCEPT";
    final bool isRejected = decision == "REJECT";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isApproved
            ? Colors.green.shade50
            : isRejected
            ? Colors.red.shade50
            : Colors.yellow.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isApproved
              ? Colors.green.shade300
              : isRejected
              ? Colors.red.shade300
              : Colors.yellow.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isApproved
                    ? Icons.check_circle
                    : isRejected
                    ? Icons.cancel
                    : Icons.info,
                color: isApproved
                    ? Colors.green
                    : isRejected
                    ? Colors.red
                    : Colors.orange,
              ),
              8.width,
              const CustomText(
                text: "Verification Result",
                fontSize: 16,
                fontFamily: "SemiBold",
              ),
            ],
          ),
          const Divider(height: 20),

          _ResultRow(label: "Expected Plate", value: expectedPlate),

          8.height,

          _ResultRow(label: "Detected Plate", value: plate),

          8.height,

          _ResultRow(label: "Decision", value: decision),

          8.height,

          _ResultRow(label: "Reason", value: reason),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: "$label: ", fontSize: 14, fontFamily: "SemiBold"),
        Expanded(
          child: CustomText(text: value, fontSize: 14, fontFamily: "Regular"),
        ),
      ],
    );
  }
}