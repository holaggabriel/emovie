import 'package:flutter/material.dart';
import '../models/category_model.dart';
import 'filter_button.dart';

class FilterSelector extends StatefulWidget {
  final List<CategoryModel> categories;
  final ValueChanged<CategoryModel> onCategorySelected;

  const FilterSelector({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  State<FilterSelector> createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  late List<CategoryModel> _categories;

  @override
  void initState() {
    super.initState();
    _categories = widget.categories;
  }

  void _handleCategoryTap(CategoryModel category) {
    setState(() {
      _categories = _categories.map((c) {
        return c.id == category.id
            ? c.copyWith(isSelected: true)
            : c.copyWith(isSelected: false);
      }).toList();
    });

    widget.onCategorySelected(category);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((category) {
          return FilterButton(
            category: category,
            onTap: () => _handleCategoryTap(category),
          );
        }).toList(),
      ),
    );
  }
}
