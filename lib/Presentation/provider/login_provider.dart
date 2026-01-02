import 'package:ats_app/Data/model/request_model/login_req_model.dart';
import 'package:ats_app/Domain/entities/login_entity.dart';
import 'package:ats_app/Domain/usecases/login_usecases.dart';
import 'package:ats_app/Presentation/screens/bottom_navigation/bottom_navigation_bar.dart';
import 'package:ats_app/utilities/preferences.dart';
import 'package:ats_app/widgets/custom_toast.dart';
import 'package:extensions_pro/extensions_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_loader.dart';
import 'bottom_navigation_provider.dart';

class LoginProvider extends ChangeNotifier {
  LoginUseCases loginUseCases;

  LoginProvider({required this.loginUseCases});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool passwordVisible = true;
  LoginEntity? loginEntity;
  bool isLoading = false;

  void passwordVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  Future<LoginEntity?> loginApi() async {
    isLoading = true;
    CustomLoader.showLoader("Please wait...");
    try {
      LoginReqModel loginReqModel = LoginReqModel(
        email: emailController.text,
        password: passwordController.text,
      );
      notifyListeners();
      loginEntity = await loginUseCases.execute(loginReqModel);
      return loginEntity;
    } catch (e) {
      loginEntity = null;
    } finally {
      CustomLoader.closeLoader();
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  void login(BuildContext context)async {
    await loginApi().then((value) async {
      final navigationProvider = Provider.of<BottomNavigationProvider>(context,listen: false);
      if (!context.mounted) return;
      if (value != null) {
        if (value.status == true) {
          await Preferences.setPreferences();
          Preferences.setUserId(value.data![0].userId.toString());
          Preferences.setToken(value.data![0].token.toString());
          Preferences.setName(value.data![0].fullName.toString());
          Preferences.setEmail(value.data![0].email.toString());
          Preferences.setImage(value.data![0].imageUpload.toString());
          navigationProvider.updateIndex(0);
          context.push(BottomNavigationBarScreen());
        } else {
          context.showErrorToast(msg: value.message.toString(), toastLength: Toast.LENGTH_SHORT);
        }
      }
    });
  }
}
