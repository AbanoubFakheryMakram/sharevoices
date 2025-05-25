import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharevoices/controllers/category_controller.dart';
import 'package:sharevoices/models/category_model.dart';

class AddCategoryView extends ConsumerWidget {
  final CategoryModel? category;
  const AddCategoryView({super.key, this.category});

  @override
  Widget build(BuildContext context, ref) {
    final vm = ref.watch(categoryController);

    return Scaffold(
      appBar: AppBar(title: Text(category == null ? "Add Category" : "Edit Category")),
      body: Form(
        key: vm.formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  validator: (input) {
                    if ((input?.length ?? 0) < 4) {
                      return 'Min length is 4';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => vm.onSubmit(context),
                  controller: vm.categoryNameController,
                  cursorColor: Theme.of(context).colorScheme.inversePrimary,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.inversePrimary)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.inversePrimary)),
                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.error)),
                    labelText: "Category name",
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                ),
                const SizedBox(height: 35),
                Center(
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: 54,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                        backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.inversePrimary),
                      ),
                      onPressed: () => vm.onSubmit(context, category: category),
                      child: Text(
                        category == null ? 'Create' : 'Update',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
