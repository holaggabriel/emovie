import 'package:flutter/material.dart';
import '../models/category_model.dart';

class FilterButton extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = category.isSelected;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white,
            width: 1
          ),
        ),
        child: Text(
          category.name,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}