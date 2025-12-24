import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionProvider extends ChangeNotifier{

  bool permissionsGranted = false;

  Future<void> checkAndRequestPermissions() async {
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
      ].request();

      if (statuses[Permission.camera]!.isGranted) {
        permissionsGranted = true;
      } else {
        permissionsGranted = false;
        if (statuses[Permission.camera]!.isPermanentlyDenied) {
          openAppSettings();
        }
      }
    } else {
      permissionsGranted = true;
    }
    notifyListeners();
  }
}