class CategoryModel {
  final int id;
  final String name;
  final bool isSelected;

  const CategoryModel({
    required this.id,
    required this.name,
    this.isSelected = false,
  });

  CategoryModel copyWith({bool? isSelected}) {
    return CategoryModel(
      id: id,
      name: name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}