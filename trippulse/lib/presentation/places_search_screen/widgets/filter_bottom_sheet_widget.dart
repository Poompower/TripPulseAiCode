import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Bottom sheet for category filtering
class FilterBottomSheetWidget extends StatefulWidget {
  final Set<String> selectedCategories;
  final ValueChanged<Set<String>> onApplyFilters;

  const FilterBottomSheetWidget({
    super.key,
    required this.selectedCategories,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Set<String> _tempSelectedCategories;

  final List<Map<String, dynamic>> _categoryGroups = [
    {
      'title': 'Cultural & Historic',
      'categories': ['Museums', 'Historic Sites', 'Art Galleries', 'Monuments'],
    },
    {
      'title': 'Food & Dining',
      'categories': ['Restaurants', 'Cafes', 'Bars', 'Food Markets'],
    },
    {
      'title': 'Nature & Outdoors',
      'categories': ['Parks', 'Beaches', 'Gardens', 'Viewpoints'],
    },
    {
      'title': 'Entertainment',
      'categories': ['Theaters', 'Cinemas', 'Shopping', 'Nightlife'],
    },
    {
      'title': 'Activities',
      'categories': ['Sports', 'Adventure', 'Tours', 'Workshops'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tempSelectedCategories = Set.from(widget.selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(maxHeight: 80.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Categories',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _tempSelectedCategories.clear();
                    });
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Category groups
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              itemCount: _categoryGroups.length,
              itemBuilder: (context, index) {
                final group = _categoryGroups[index];
                return _buildCategoryGroup(
                  context,
                  group['title'] as String,
                  group['categories'] as List<String>,
                );
              },
            ),
          ),

          // Apply button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApplyFilters(_tempSelectedCategories);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Apply Filters${_tempSelectedCategories.isNotEmpty ? ' (${_tempSelectedCategories.length})' : ''}',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGroup(
    BuildContext context,
    String title,
    List<String> categories,
  ) {
    final theme = Theme.of(context);

    return ExpansionTile(
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      initiallyExpanded: true,
      children: categories.map((category) {
        final isSelected = _tempSelectedCategories.contains(category);
        return CheckboxListTile(
          title: Text(category),
          value: isSelected,
          onChanged: (value) {
            setState(() {
              if (value == true) {
                _tempSelectedCategories.add(category);
              } else {
                _tempSelectedCategories.remove(category);
              }
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        );
      }).toList(),
    );
  }
}
