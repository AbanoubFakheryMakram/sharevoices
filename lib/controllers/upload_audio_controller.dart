import 'package:file_picker/src/file_picker_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharevoices/main.dart';
import 'package:sharevoices/services/database/crud_operations.dart';
import 'package:sharevoices/services/messages/messages_service.dart';
import 'package:sharevoices/services/permissions/permissions_services.dart';
import 'package:sharevoices/services/pick_files/pick_files_service.dart';
import 'package:toastification/toastification.dart';

final uploadAudioControllerProvider = Provider<UploadAudioController>((ref) => UploadAudioController());

class UploadAudioController extends ChangeNotifier {
  Future<void> onUploadAudio(int categoryId) async {
    if (await _requestStoragePermission()) {
      final result = await providerContainer.read(pickFilesServiceProvider).pickFiles();
      await _onFilesPicked(result, categoryId);
    }
  }

  Future<void> _onFilesPicked(FilePickerResult? result, int categoryId) async {
    if (result != null) {
      for (final file in result.files) {
        await providerContainer.read(crudOperationsProvider).insertRecord(
              file.path!,
              file.name,
              categoryId,
            );
      }
    }

    notifyListeners();
  }

  Future<bool> _requestStoragePermission() async {
    bool accepted = await providerContainer.read(permissionsServiceProvider).requestStoragePermission();
    if (!accepted) {
      providerContainer
          .read(messagesServiceProvider)
          .showStyledToast('Permission not granted', ToastificationType.error);
      return false;
    }

    return true;
  }
}
