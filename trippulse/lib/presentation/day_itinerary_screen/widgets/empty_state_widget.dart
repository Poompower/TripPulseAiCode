import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Empty state widget for day itinerary
/// Shown when no places are added to the day
class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onAddPlaces;

  const EmptyStateWidget({super.key, required this.onAddPlaces});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.3,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'explore_outlined',
                  size: 20.w,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'No Places Added Yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Start building your day itinerary by adding places you want to visit',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: onAddPlaces,
              icon: CustomIconWidget(
                iconName: 'add_location',
                size: 24,
                color: theme.colorScheme.onPrimary,
              ),
              label: const Text('Find Places to Visit'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              ),
            ),
            SizedBox(height: 2.h),
            TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => _buildTipsDialog(context),
                );
              },
              icon: CustomIconWidget(
                iconName: 'lightbulb_outline',
                size: 20,
                color: theme.colorScheme.primary,
              ),
              label: const Text('Tips for Planning'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsDialog(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          CustomIconWidget(
            iconName: 'lightbulb',
            size: 24,
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: 2.w),
          const Text('Planning Tips'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTipItem(
              context,
              icon: 'schedule',
              title: 'Consider Visit Duration',
              description:
                  'Each place shows estimated visit time to help you plan',
            ),
            SizedBox(height: 2.h),
            _buildTipItem(
              context,
              icon: 'route',
              title: 'Optimize Your Route',
              description: 'Drag places to reorder and minimize travel time',
            ),
            SizedBox(height: 2.h),
            _buildTipItem(
              context,
              icon: 'note',
              title: 'Add Personal Notes',
              description: 'Swipe right on places to add notes and reminders',
            ),
            SizedBox(height: 2.h),
            _buildTipItem(
              context,
              icon: 'map',
              title: 'View on Map',
              description: 'See all places on map to visualize your day',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Got it'),
        ),
      ],
    );
  }

  Widget _buildTipItem(
    BuildContext context, {
    required String icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
