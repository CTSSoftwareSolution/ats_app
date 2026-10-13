import 'dart:async';

import 'package:ats_app/Data/model/request_model/send_otp_req_model.dart';
import 'package:ats_app/Domain/entities/send_otp_entity.dart';
import 'package:ats_app/Domain/usecases/send_otp_usecases.dart';
import 'package:ats_app/utilities/validators.dart';
import 'package:flutter/cupertino.dart';

import '../../widgets/custom_loader.dart';

/// Step 1 of the forgot password flow. Owns the email for the whole flow so
/// the verify / reset steps can read it.
class SendOtpProvider extends ChangeNotifier {
  SendOtpUseCases sendOtpUseCases;

  SendOtpProvider({required this.sendOtpUseCases});

  static const int resendCooldownSeconds = 30;
  static const String _genericError = "Something went wrong. Please try again.";

  SendOtpEntity? sendOtpEntity;

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  Timer? _resendTimer;
  int resendSecondsLeft = 0;

  String get email => emailController.text.trim().toLowerCase();

  bool get canResendOtp => !isLoading && resendSecondsLeft == 0;

  String? validateEmail(String? value) =>
      Validators.emailValidation((value ?? "").trim().toLowerCase());

  /// Clears state left over from a previous attempt. Does not notify so it can
  /// be called from initState.
  void startFlow() {
    _resendTimer?.cancel();
    resendSecondsLeft = 0;
    isLoading = false;
    errorMessage = null;
    successMessage = null;
    sendOtpEntity = null;
    emailController.clear();
  }

  void clearMessages() {
    if (errorMessage == null && successMessage == null) return;
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }

  Future<SendOtpEntity?> fetchOtp() async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    CustomLoader.showLoader("Please wait...");
    notifyListeners();
    try {
      sendOtpEntity = await sendOtpUseCases.execute(SendOtpReqModel(email: email));
      return sendOtpEntity;
    } catch (e) {
      debugPrint("Send OTP error: $e");
      sendOtpEntity = null;
    } finally {
      isLoading = false;
      CustomLoader.closeLoader();
      notifyListeners();
    }
    return null;
  }

  /// Validates the email form and sends the OTP. Returns true on success so
  /// the screen can move to the verify step.
  Future<bool> submit() async {
    if (isLoading) return false;
    if (!(formKey.currentState?.validate() ?? false)) return false;
    return _sendOtp();
  }

  /// Requests a new OTP once the cooldown has passed. Returns true when sent.
  Future<bool> resendOtp() async {
    if (!canResendOtp) return false;
    return _sendOtp();
  }

  Future<bool> _sendOtp() async {
    if (isLoading) return false;
    final value = await fetchOtp();
    if (value?.success == true) {
      successMessage = _nonEmpty(value?.message) ?? "OTP has been sent to your registered email.";
      _startResendTimer();
      notifyListeners();
      return true;
    }
    errorMessage = _nonEmpty(value?.message) ?? _genericError;
    notifyListeners();
    return false;
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    resendSecondsLeft = resendCooldownSeconds;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      resendSecondsLeft--;
      if (resendSecondsLeft <= 0) {
        resendSecondsLeft = 0;
        timer.cancel();
      }
      notifyListeners();
    });
  }

  String? _nonEmpty(String? value) => (value == null || value.trim().isEmpty) ? null : value;

  @override
  void dispose() {
    _resendTimer?.cancel();
    emailController.dispose();
    super.dispose();
  }
}
