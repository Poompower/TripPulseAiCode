import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Empty state widget for trip list
/// Displays when no trips exist or search returns no results
class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onCreateTrip;
  final bool isSearchActive;

  const EmptyStateWidget({
    super.key,
    required this.onCreateTrip,
    this.isSearchActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            CustomImageWidget(
              imageUrl: isSearchActive
                  ? 'https://images.unsplash.com/photo-1488190211105-8b0e65b80b4e?w=400'
                  : 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=400',
              width: 60.w,
              height: 30.h,
              fit: BoxFit.contain,
              semanticLabel: isSearchActive
                  ? 'Person looking through binoculars searching for something in the distance'
                  : 'Airplane flying over tropical beach with palm trees and turquoise water',
            ),
            SizedBox(height: 4.h),

            // Title
            Text(
              isSearchActive ? 'No Trips Found' : 'Plan Your First Trip',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),

            // Description
            Text(
              isSearchActive
                  ? 'Try adjusting your search terms or create a new trip'
                  : 'Start planning your next adventure and create unforgettable memories',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),

            // CTA Button
            if (!isSearchActive)
              ElevatedButton.icon(
                onPressed: onCreateTrip,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: theme.colorScheme.onPrimary,
                  size: 24,
                ),
                label: const Text('Create Your First Trip'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                ),
              ),

            // Search tips
            if (isSearchActive) ...[
              SizedBox(height: 3.h),
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'lightbulb_outline',
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Search Tips',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    _buildTip(
                      context,
                      'Try searching by destination (e.g., "Paris")',
                    ),
                    _buildTip(context, 'Search by trip title (e.g., "Summer")'),
                    _buildTip(context, 'Check your spelling and try again'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTip(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(top: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 0.5.h),
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
