import 'package:ats_app/Data/model/request_model/change_password_req_model.dart';
import 'package:ats_app/Domain/entities/change_password_entity.dart';
import 'package:ats_app/Domain/usecases/change_password_usecases.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:ats_app/utilities/validators.dart';
import 'package:flutter/cupertino.dart';

import '../../widgets/custom_loader.dart';

/// Change password for the logged in user (Profile > Change Password).
class ChangePasswordProvider extends ChangeNotifier {
  ChangePasswordUseCases changePasswordUseCases;

  ChangePasswordProvider({required this.changePasswordUseCases});

  static const String _genericError = "Something went wrong. Please try again.";

  ChangePasswordEntity? changePasswordEntity;

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  bool currentPasswordObscured = true;
  bool newPasswordObscured = true;
  bool confirmPasswordObscured = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? validateCurrentPassword(String? value) => Validators.currentPasswordValidation(value ?? "");

  String? validateNewPassword(String? value) =>
      Validators.changedPasswordValidation(value ?? "", currentPasswordController.text);

  String? validateConfirmPassword(String? value) =>
      Validators.confirmPasswordValidation(value ?? "", null, newPasswordController.text);

  /// Clears state left over from a previous visit. Does not notify so it can
  /// be called from initState.
  void reset() {
    isLoading = false;
    errorMessage = null;
    successMessage = null;
    changePasswordEntity = null;
    currentPasswordObscured = true;
    newPasswordObscured = true;
    confirmPasswordObscured = true;
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  void clearMessages() {
    if (errorMessage == null && successMessage == null) return;
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }

  void toggleCurrentPasswordVisibility() {
    currentPasswordObscured = !currentPasswordObscured;
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

  Future<ChangePasswordEntity?> fetchChangePassword() async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    CustomLoader.showLoader("Please wait...");
    notifyListeners();
    try {
      ChangePasswordReqModel changePasswordReqModel = ChangePasswordReqModel(
        userId: Preferences.getUserId()?.toString(),
        oldPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
      );
      changePasswordEntity = await changePasswordUseCases.execute(changePasswordReqModel);
      return changePasswordEntity;
    } catch (e) {
      debugPrint("Change password error: $e");
      changePasswordEntity = null;
    } finally {
      isLoading = false;
      CustomLoader.closeLoader();
      notifyListeners();
    }
    return null;
  }

  /// Validates the form and changes the password. Returns true on success so
  /// the screen can go back to Profile.
  Future<bool> submit() async {
    if (isLoading) return false;
    if (!(formKey.currentState?.validate() ?? false)) return false;
    final value = await fetchChangePassword();
    if (value?.success == true) {
      CustomLoader.message(_nonEmpty(value?.message) ?? "Password changed successfully.");
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
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
