import 'package:ats_app/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ip_address_provider.dart';

class ConfigProvider extends ChangeNotifier{

  final formKey = GlobalKey<FormState>();
  late Animation<Offset> slideAnimation;
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  final TextEditingController ipController = TextEditingController();
  bool isLoading = false;


  // void loadCurrentIp(BuildContext context) {
  //   final provider = Provider.of<IpAddressProvider>(context, listen: false);
  //   ipController.text = provider.baseUrl;
  // }

  Future<void> saveIpAddress(BuildContext context) async {
    if (formKey.currentState!.validate()) {
    isLoading = true;

      final provider = Provider.of<IpAddressProvider>(context, listen: false);

      // Build the full URL from IP address
      String ipAddress = ipController.text.trim();

      // If user enters just IP:PORT, add http://
      if (!ipAddress.startsWith('http://') && !ipAddress.startsWith('https://')) {
        ipAddress = 'http://$ipAddress';
      }

      final success = await provider.updateBaseUrl(ipAddress);

       isLoading = false;

      if (success) {
        CustomLoader.showSuccessSnackBar(context);
        await Future.delayed(const Duration(milliseconds: 300));
        Navigator.pop(context);
      } else {
        CustomLoader.showErrorSnackBar(context);
      }
    }
  }

}