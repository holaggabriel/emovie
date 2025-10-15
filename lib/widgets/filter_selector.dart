import 'package:flutter/material.dart';
import '../models/filter_model.dart';
import 'filter_button.dart';

class FilterSelector extends StatefulWidget {
  final List<FilterModel> filters;
  final ValueChanged<FilterModel> onFilterSelected;
  final FilterModel? selectedFilter;

  const FilterSelector({
    super.key,
    required this.filters,
    required this.onFilterSelected,
    this.selectedFilter,
  });

  @override
  State<FilterSelector> createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  late FilterModel? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.selectedFilter;
  }

  void _handleFilterTap(FilterModel filter) {
    setState(() {
      _selectedFilter = filter;
    });

    widget.onFilterSelected(filter);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.filters.map((filter) {
          final isSelected = filter == _selectedFilter;
          return FilterButton(
            filter: filter,
            isSelected: isSelected,
            onTap: () => _handleFilterTap(filter),
          );
        }).toList(),
      ),
    );
  }
}
