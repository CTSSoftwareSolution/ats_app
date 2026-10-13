import 'package:ats_app/Data/model/request_model/reset_password_req_model.dart';
import 'package:ats_app/Domain/entities/reset_password_entity.dart';
import 'package:ats_app/Domain/usecases/reset_password_usecases.dart';
import 'package:ats_app/utilities/validators.dart';
import 'package:flutter/cupertino.dart';

import '../../utilities/color_data.dart';
import '../../widgets/custom_loader.dart';
import 'send_otp_provider.dart';
import 'verify_otp_provider.dart';

/// Step 3 of the forgot password flow – set the new password.
class ResetPasswordProvider extends ChangeNotifier {
  ResetPasswordUseCases resetPasswordUseCases;

  final SendOtpProvider sendOtpProvider;
  final VerifyOtpProvider verifyOtpProvider;

  ResetPasswordProvider({
    required this.resetPasswordUseCases,
    required this.sendOtpProvider,
    required this.verifyOtpProvider,
  });

  static const String _genericError = "Something went wrong. Please try again.";

  ResetPasswordEntity? resetPasswordEntity;

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  bool newPasswordObscured = true;
  bool confirmPasswordObscured = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();


  static const EdgeInsets fieldPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 14);
  static const TextStyle hintStyle =
  TextStyle(fontSize: 14, fontFamily: "Medium", color: textMuted);

  String? validateNewPassword(String? value) => Validators.newPasswordValidation(value ?? "");

  String? validateConfirmPassword(String? value) =>
      Validators.confirmPasswordValidation(value ?? "", null, newPasswordController.text);

  /// Clears state left over from a previous attempt. Does not notify so it can
  /// be called from initState.
  void reset() {
    isLoading = false;
    errorMessage = null;
    successMessage = null;
    resetPasswordEntity = null;
    newPasswordObscured = true;
    confirmPasswordObscured = true;
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  void clearMessages() {
    if (errorMessage == null && successMessage == null) return;
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    newPasswordObscured = !newPasswordObscured;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    confirmPasswordObscured = !confirmPasswordObscured;
    notifyListeners();
  }

  Future<ResetPasswordEntity?> fetchResetPassword({required String email, required String otp}) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    CustomLoader.showLoader("Please wait...");
    notifyListeners();
    try {
      ResetPasswordReqModel resetPasswordReqModel = ResetPasswordReqModel(
        email: email,
        otp: otp,
        newPassword: newPasswordController.text,
      );
      resetPasswordEntity = await resetPasswordUseCases.execute(resetPasswordReqModel);
      return resetPasswordEntity;
    } catch (e) {
      debugPrint("Reset password error: $e");
      resetPasswordEntity = null;
    } finally {
      isLoading = false;
      CustomLoader.closeLoader();
      notifyListeners();
    }
    return null;
  }

  /// Validates the form and resets the password for the email / OTP from the
  /// earlier steps. Returns true on success so the screen can return to login.
  Future<bool> submit() async {
    if (isLoading) return false;
    if (!(formKey.currentState?.validate() ?? false)) return false;
    final value = await fetchResetPassword(
      email: sendOtpProvider.email,
      otp: verifyOtpProvider.otpForReset,
    );
    if (value?.success == true) {
      CustomLoader.message(_nonEmpty(value?.message) ?? "Password reset successfully.");
      // Flow finished: drop the email, OTP and passwords.
      sendOtpProvider.startFlow();
      verifyOtpProvider.reset();
      reset();
      notifyListeners();
      return true;
    }
    errorMessage = _nonEmpty(value?.message) ?? _genericError;
    notifyListeners();
    return false;
  }

  String? _nonEmpty(String? value) => (value == null || value.trim().isEmpty) ? null : value;

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
