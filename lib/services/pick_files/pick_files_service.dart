import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pickFilesServiceProvider = Provider<PickFilesService>((ref) => PickFilesService());

class PickFilesService {
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.audio,
    List<String> allowedExtensions = const ['mp3', 'wav', 'aac', 'ogg', 'flac'],
    Function(FilePickerStatus p1)? onFileLoading,
    int compressionQuality = 30,
    bool allowMultiple = true,
    bool withData = true,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async {
    return await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      allowedExtensions: allowedExtensions,
      type: FileType.custom,
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      onFileLoading: onFileLoading,
      compressionQuality: compressionQuality,
      withData: withData,
      withReadStream: withReadStream,
      lockParentWindow: lockParentWindow,
      readSequential: readSequential,
    );
  }
}
