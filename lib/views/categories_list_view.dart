import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharevoices/controllers/category_controller.dart';
import 'package:sharevoices/controllers/category_id_provider.dart';
import 'package:sharevoices/services/database/crud_operations.dart';
import 'package:sharevoices/views/add_category_view.dart';
import 'package:sharevoices/views/playlist_audios_view.dart';
import 'package:sharevoices/widgets/app_decorated_box.dart';

class CategoriesListView extends ConsumerStatefulWidget {
  const CategoriesListView({super.key});

  @override
  ConsumerState createState() => _CategoriesListViewState();
}

class _CategoriesListViewState extends ConsumerState<CategoriesListView> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(crudOperationsProvider).readCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final crudVM = ref.watch(crudOperationsProvider);
    return GridView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: crudVM.categories.length + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 18,
        crossAxisSpacing: 18,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        if (index == 0) {
          return AppDecoratedBox(
            onPressed: () {
              ref.read(categoryController).clear();
              Navigator.of(context).push(CupertinoPageRoute(builder: (_) => const AddCategoryView()));
            },
            color: Theme.of(context).colorScheme.primary,
            child: Icon(
              Icons.create_new_folder_rounded,
              size: 35,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          );
        }
        return LayoutBuilder(
          builder: (context, constraints) => Stack(
            fit: StackFit.expand,
            children: [
              AppDecoratedBox(
                onPressed: () {
                  ref.read(categoryIdProvider.notifier).state = crudVM.categories[index - 1].id!;
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => PlaylistAudiosView(
                        category: crudVM.categories[index - 1],
                      ),
                    ),
                  );
                },
                color: Theme.of(context).colorScheme.primary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AvatarPlus(
                      height: 85,
                      crudVM.categories[index - 1].id.toString(),
                      trBackground: true,
                    ),
                    Text(
                      crudVM.categories[index - 1].categoryName ?? '',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () {
                    ref.read(crudOperationsProvider).deleteCategory(crudVM.categories[index - 1].id!);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                  onPressed: () {
                    ref.read(categoryController).clear();
                    ref.read(categoryController).setCategoryName(crudVM.categories[index - 1].categoryName ?? '');
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (_) => AddCategoryView(category: crudVM.categories[index - 1]),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.edit_sharp,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
