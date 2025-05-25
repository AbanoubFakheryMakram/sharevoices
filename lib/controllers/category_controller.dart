import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharevoices/main.dart';
import 'package:sharevoices/models/category_model.dart';
import 'package:sharevoices/services/database/crud_operations.dart';

final categoryController = ChangeNotifierProvider<CategoryController>((ref) => CategoryController());

class CategoryController extends ChangeNotifier {
  int selectedAvatarIndex = 0;
  bool loading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController categoryNameController = TextEditingController();

  void clear() {
    selectedAvatarIndex = 0;
    categoryNameController.clear();
    formKey = GlobalKey<FormState>();
    loading = false;
  }

  void setCategoryName(String name) {
    categoryNameController.text = name;
  }

  void setSelectedAvatarIndex(int index) {
    selectedAvatarIndex = index;
    notifyListeners();
  }

  void onSubmit(BuildContext context, {CategoryModel? category}) async {
    if (formKey.currentState!.validate()) {
      setLoading(true);
      final crudVM = providerContainer.read(crudOperationsProvider);
      if (category != null) {
        await crudVM.updateCategory(
          categoryNameController.text,
          category.id!,
        );
      } else {
        await crudVM.createCategory(
          '${crudVM.categories.isEmpty ? 1 : crudVM.categories.last.id! + 1}',
          categoryNameController.text,
        );
      }
      await crudVM.readCategories();
      setLoading(false);
      Navigator.pop(context);
      clear();
    }
  }

  void setLoading(bool state) {
    loading = state;
    notifyListeners();
  }
}
