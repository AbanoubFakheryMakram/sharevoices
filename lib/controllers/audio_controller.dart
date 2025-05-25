import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharevoices/main.dart';
import 'package:sharevoices/models/record_model.dart';
import 'package:sharevoices/services/database/crud_operations.dart';
import 'package:sharevoices/widgets/categories_sheet.dart';

final audioController = ChangeNotifierProvider<AudioController>((ref) => AudioController());

class AudioController extends ChangeNotifier {
  AudioPlayer audioPlayer = AudioPlayer();
  int playingIndex = -1;
  Duration positionDuration = Duration.zero;

  void play(String path, int index) async {
    if (audioPlayer.state == PlayerState.paused && index == playingIndex) {
      await resume();
    } else {
      await pause();
      await stop();
      await audioPlayer.play(DeviceFileSource(path));
      playingIndex = index;
    }

    notifyListeners();

    _listenToAudio();
  }

  Future<void> pause({bool withNotify = true}) async {
    await audioPlayer.pause();
    if (withNotify) notifyListeners();
  }

  Future<void> stop({bool withNotify = true}) async {
    await audioPlayer.stop();
    playingIndex = -1;
    positionDuration = Duration.zero;
    if (withNotify) notifyListeners();
  }

  Future<void> resume() async {
    await audioPlayer.resume();
  }

  bool isPlaying() => audioPlayer.state == PlayerState.playing;

  void _listenToAudio() {
    audioPlayer.onPlayerStateChanged.listen((state) {
      notifyListeners();
    });

    audioPlayer.onPositionChanged.listen((position) {
      positionDuration = position;
      notifyListeners();
    });

    audioPlayer.onPlayerComplete.listen((_) {
      stop();
    });
  }

  void seekTo(double position) {
    audioPlayer.seek(Duration(seconds: position.toInt()));
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void showEditNameSheet(BuildContext context, RecordModel record) {
    TextEditingController nameController = TextEditingController(text: record.recordName);
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Edit Name',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  cursorColor: Theme.of(context).colorScheme.inversePrimary,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.inversePrimary)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.inversePrimary)),
                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.error)),
                    labelText: "Enter new name",
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 35),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: 54,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                      backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.inversePrimary),
                    ),
                    onPressed: () {
                      if (nameController.text.isNotEmpty) {
                        String newName = nameController.text;
                        updateRecordName(newName, record);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
                const SizedBox(height: 35),
              ],
            ),
          ),
        );
      },
    );
  }

  void showCategoriesSheet(BuildContext context, RecordModel record) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return CategoriesSheet(record: record);
      },
    );
  }

  void updateRecordName(String newName, RecordModel record) async {
    await providerContainer.read(crudOperationsProvider).updateRecord(newName, record.id!, record.categoryId!);
    providerContainer.read(crudOperationsProvider).readRecords(record.categoryId!);
  }
}
