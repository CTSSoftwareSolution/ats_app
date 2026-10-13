import 'package:ats_app/Data/model/request_model/verify_otp_req_model.dart';
import 'package:ats_app/Domain/entities/verify_otp_entity.dart';
import 'package:ats_app/Domain/usecases/verify_otp_usecases.dart';
import 'package:flutter/cupertino.dart';

import '../../widgets/custom_loader.dart';

/// Step 2 of the forgot password flow. Keeps the verified OTP because the
/// reset API needs it again.
class VerifyOtpProvider extends ChangeNotifier {
  VerifyOtpUseCases verifyOtpUseCases;

  VerifyOtpProvider({required this.verifyOtpUseCases});

  static const String _genericError = "Something went wrong. Please try again.";

  VerifyOtpEntity? verifyOtpEntity;

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  String? verifiedOtp;

  final otpController = TextEditingController();

  String get otp => otpController.text.trim();

  /// Clears state left over from a previous attempt / OTP.
  void reset() {
    isLoading = false;
    errorMessage = null;
    successMessage = null;
    verifiedOtp = null;
    verifyOtpEntity = null;
    otpController.clear();
    notifyListeners();
  }

  void clearMessages() {
    if (errorMessage == null && successMessage == null) return;
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }

  Future<VerifyOtpEntity?> fetchVerifyOtp(String email) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    CustomLoader.showLoader("Please wait...");
    notifyListeners();
    try {
      verifyOtpEntity = await verifyOtpUseCases.execute(VerifyOtpReqModel(email: email, otp: otp));
      return verifyOtpEntity;
    } catch (e) {
      debugPrint("Verify OTP error: $e");
      verifyOtpEntity = null;
    } finally {
      isLoading = false;
      CustomLoader.closeLoader();
      notifyListeners();
    }
    return null;
  }

  /// Returns true when the OTP is valid for [email].
  Future<bool> verifyOtp(String email) async {
    if (isLoading) return false;
    final enteredOtp = otp;
    final value = await fetchVerifyOtp(email);
    if (value?.success == true) {
      verifiedOtp = enteredOtp;
      successMessage = _nonEmpty(value?.message) ?? "OTP verified successfully.";
      notifyListeners();
      return true;
    }
    verifiedOtp = null;
    errorMessage = _nonEmpty(value?.message) ?? _genericError;
    notifyListeners();
    return false;
  }

  String? _nonEmpty(String? value) => (value == null || value.trim().isEmpty) ? null : value;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
}
