import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharevoices/controllers/audio_controller.dart';
import 'package:sharevoices/controllers/upload_audio_controller.dart';
import 'package:sharevoices/main.dart';
import 'package:sharevoices/models/category_model.dart';
import 'package:sharevoices/services/database/crud_operations.dart';
import 'package:sharevoices/widgets/record_tile.dart';

class PlaylistAudiosView extends ConsumerStatefulWidget {
  final CategoryModel category;
  const PlaylistAudiosView({super.key, required this.category});

  @override
  ConsumerState createState() => _PlaylistAudiosViewState();
}

class _PlaylistAudiosViewState extends ConsumerState<PlaylistAudiosView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(crudOperationsProvider).readRecords(widget.category.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.categoryName!),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              child: AvatarPlus(widget.category.categoryAvatar),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await ref.read(uploadAudioControllerProvider).onUploadAudio(widget.category.id!);
          ref.read(crudOperationsProvider).readRecords(widget.category.id!);
        },
        child: Icon(
          Icons.upload,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: ref.watch(crudOperationsProvider).loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ref.watch(crudOperationsProvider).records.length,
              itemBuilder: (context, index) {
                return RecordTile(
                  recordModel: ref.watch(crudOperationsProvider).records[index],
                  index: index,
                );
              },
            ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      ref.read(audioController).pause();
    } else if (state == AppLifecycleState.resumed && ref.read(audioController).playingIndex != -1) {
      ref.read(audioController).resume();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    providerContainer.read(audioController).pause(withNotify: false);
    providerContainer.read(audioController).stop(withNotify: false);
    super.dispose();
  }
}
