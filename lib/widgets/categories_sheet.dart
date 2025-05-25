import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharevoices/models/record_model.dart';
import 'package:sharevoices/services/database/crud_operations.dart';

class CategoriesSheet extends ConsumerStatefulWidget {
  final RecordModel record;
  const CategoriesSheet({super.key, required this.record});

  @override
  ConsumerState createState() => _CategoriesSheetState();
}

class _CategoriesSheetState extends ConsumerState<CategoriesSheet> {
  int currentCategory = 0;

  @override
  void initState() {
    super.initState();

    currentCategory = ref.read(crudOperationsProvider).categories.indexWhere((c) => c.id == widget.record.categoryId!);
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.read(crudOperationsProvider).categories;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Move this record to new category', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: currentCategory == index ? const Icon(Icons.check, size: 18,) : null,
                  onTap: () {
                    setState(() {
                      currentCategory = index;
                    });
                  },
                  title: Text(categories[index].categoryName!),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    size: 18,
                  ),
                );
              },
              itemCount: categories.length,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: 54,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                  backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.inversePrimary),
                ),
                onPressed: () {
                  ref
                      .read(crudOperationsProvider)
                      .updateRecord(widget.record.recordName, widget.record.id!, categories[currentCategory].id!);
                  ref.read(crudOperationsProvider).readRecords(widget.record.categoryId!);
                  Navigator.pop(context);
                },
                child: const Text('Submit'),
              ),
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}
