import 'package:ats_app/Data/model/request_model/reset_password_req_model.dart';
import 'package:ats_app/Domain/entities/reset_password_entity.dart';
import 'package:ats_app/Domain/usecases/reset_password_usecases.dart';
import 'package:flutter/cupertino.dart';

import '../../widgets/custom_loader.dart';

/// Step 3 of the forgot password flow – set the new password.
class ResetPasswordProvider extends ChangeNotifier {
  ResetPasswordUseCases resetPasswordUseCases;

  ResetPasswordProvider({required this.resetPasswordUseCases});

  static const String _genericError = "Something went wrong. Please try again.";

  ResetPasswordEntity? resetPasswordEntity;

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  bool newPasswordObscured = true;
  bool confirmPasswordObscured = true;

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  /// Clears state left over from a previous attempt.
  void reset() {
    isLoading = false;
    errorMessage = null;
    successMessage = null;
    resetPasswordEntity = null;
    newPasswordObscured = true;
    confirmPasswordObscured = true;
    newPasswordController.clear();
    confirmPasswordController.clear();
    notifyListeners();
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

  /// Returns true when the password was changed.
  Future<bool> resetPassword({required String email, required String otp}) async {
    if (isLoading) return false;
    final value = await fetchResetPassword(email: email, otp: otp);
    if (value?.success == true) {
      successMessage = _nonEmpty(value?.message) ?? "Password reset successfully.";
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
