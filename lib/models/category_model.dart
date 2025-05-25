class CategoryModel {
  final int? id;
  final String categoryAvatar;
  final String? categoryName;

  CategoryModel({
    this.id,
    required this.categoryAvatar,
    required this.categoryName,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int,
      categoryAvatar: map['category_avatar'] as String,
      categoryName: map['category_name'] as String,
    );
  }
}
