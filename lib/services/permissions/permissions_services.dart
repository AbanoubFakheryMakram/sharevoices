import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final permissionsServiceProvider = Provider<PermissionsServices>((ref) => PermissionsServices());

class PermissionsServices {
  Future<bool> requestStoragePermission() async {
    bool accepted = false;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      // before android 13
      if (androidInfo.version.sdkInt < 33) {
        accepted = await _requestPermission(Permission.storage);
      } else {
        accepted = await _requestPermission(Permission.audio);
      }
    }

    return accepted;
  }

  Future<bool> _requestPermission(Permission permission) async {
    return (await permission.request()) != PermissionStatus.denied;
  }
}
