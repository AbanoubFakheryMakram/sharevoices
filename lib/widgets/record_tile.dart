import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sharevoices/controllers/audio_controller.dart';
import 'package:sharevoices/controllers/category_id_provider.dart';
import 'package:sharevoices/models/record_model.dart';
import 'package:sharevoices/services/database/crud_operations.dart';

import 'app_decorated_box.dart';

class RecordTile extends ConsumerWidget {
  final RecordModel recordModel;
  final int index;

  const RecordTile({
    super.key,
    required this.recordModel,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(audioController);

    return SizedBox(
      height: 90,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              height: 75,
              width: 75,
              child: AppDecoratedBox(
                color: recordModel.color,
                withShadow: false,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AvatarPlus(
                    '${recordModel.recordName}$index',
                    trBackground: true,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 45,
                    height: 4,
                    child: AppDecoratedBox(
                      color: recordModel.color,
                      withShadow: false,
                    ),
                  ),
                  Text(
                    recordModel.recordName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(vm.formatDuration(recordModel.duration ?? Duration.zero)),
                  SliderTheme(
                    data: SliderThemeData(overlayShape: SliderComponentShape.noThumb),
                    child: Slider(
                      activeColor: recordModel.color,
                      inactiveColor: Theme.of(context).colorScheme.secondary,
                      value: vm.playingIndex == index ? vm.positionDuration.inSeconds.toDouble() : 0,
                      onChanged: (double position) {
                        vm.seekTo(position);
                      },
                      min: 0,
                      max: vm.playingIndex == index ? recordModel.duration!.inSeconds.toDouble() : 0,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PopupMenuButton(
                  onSelected: (String value) async {
                    if (value == 'Share') {
                      if (vm.isPlaying()) {
                        await vm.pause();
                      }
                      await Share.shareXFiles(
                        [
                          XFile(recordModel.recordPath),
                        ],
                        text: 'Share Sound',
                      );
                    } else if (value == 'Delete') {
                      if (vm.isPlaying()) {
                        await vm.pause();
                        await vm.stop();
                      }
                      ref.read(crudOperationsProvider).deleteRecord(recordModel.id!, ref.watch(categoryIdProvider));
                    } else if (value == 'Edit') {
                      if (vm.isPlaying()) {
                        await vm.pause();
                        await vm.stop();
                      }
                      vm.showEditNameSheet(context, recordModel);
                    } else if (value == 'Move') {
                      if (vm.isPlaying()) {
                        await vm.pause();
                        await vm.stop();
                      }
                      vm.showCategoriesSheet(context, recordModel);
                    }
                  },
                  itemBuilder: (context) {
                    return <PopupMenuItem<String>>[
                      const PopupMenuItem<String>(
                        value: 'Share',
                        child: Text('Share'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Delete',
                        child: Text('Delete'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Edit',
                        child: Text('Edit Name'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Move',
                        child: Text('Move To'),
                      ),
                    ];
                  },
                ),
                GestureDetector(
                  child: Icon(
                    vm.isPlaying() && vm.playingIndex == index ? Icons.pause : Icons.play_arrow,
                    size: 24,
                  ),
                  onTap: () {
                    if (vm.isPlaying() && vm.playingIndex == index) {
                      vm.pause();
                    } else {
                      vm.play(recordModel.recordPath, index);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
