import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Empty state widget with helpful suggestions
class EmptySearchStateWidget extends StatelessWidget {
  final String searchQuery;
  final VoidCallback onClearSearch;

  const EmptySearchStateWidget({
    super.key,
    required this.searchQuery,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 64,
            ),
            SizedBox(height: 3.h),
            Text(
              searchQuery.isEmpty ? 'Start Searching' : 'No Results Found',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              searchQuery.isEmpty
                  ? 'Search for attractions, restaurants, museums, and more in your destination'
                  : 'We couldn\'t find any places matching "$searchQuery"',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),

            if (searchQuery.isNotEmpty)
              ElevatedButton.icon(
                onPressed: onClearSearch,
                icon: CustomIconWidget(
                  iconName: 'clear',
                  color: theme.colorScheme.onPrimary,
                  size: 20,
                ),
                label: const Text('Clear Search'),
              ),

            if (searchQuery.isEmpty) ...[
              Text(
                'Popular Searches:',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                alignment: WrapAlignment.center,
                children:
                    [
                      'Museums',
                      'Restaurants',
                      'Parks',
                      'Historic Sites',
                      'Beaches',
                    ].map((suggestion) {
                      return ActionChip(
                        label: Text(suggestion),
                        onPressed: () {
                          // Trigger search with suggestion
                        },
                      );
                    }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
