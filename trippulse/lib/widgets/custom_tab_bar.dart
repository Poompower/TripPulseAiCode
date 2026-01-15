import 'package:flutter/material.dart';

/// Custom tab bar for TripPulse application
/// Implements horizontal tab navigation with smooth transitions
/// Optimized for day-by-day itinerary navigation and content filtering
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// List of tab labels
  final List<String> tabs;

  /// Current selected tab index
  final int currentIndex;

  /// Callback when tab is tapped
  final ValueChanged<int> onTap;

  /// Tab bar variant
  final TabBarVariant variant;

  /// Whether tabs should be scrollable
  final bool isScrollable;

  /// Custom indicator color (optional, uses theme if null)
  final Color? indicatorColor;

  /// Custom label color (optional, uses theme if null)
  final Color? labelColor;

  /// Custom unselected label color (optional, uses theme if null)
  final Color? unselectedLabelColor;

  /// Custom background color (optional, transparent if null)
  final Color? backgroundColor;

  /// Indicator weight (thickness)
  final double indicatorWeight;

  /// Tab alignment for scrollable tabs
  final TabAlignment? tabAlignment;

  /// Custom padding for tabs
  final EdgeInsetsGeometry? padding;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.variant = TabBarVariant.standard,
    this.isScrollable = false,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.backgroundColor,
    this.indicatorWeight = 2.0,
    this.tabAlignment,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case TabBarVariant.standard:
        return _buildStandardTabBar(context);
      case TabBarVariant.pills:
        return _buildPillsTabBar(context);
      case TabBarVariant.segmented:
        return _buildSegmentedTabBar(context);
      case TabBarVariant.minimal:
        return _buildMinimalTabBar(context);
    }
  }

  /// Builds standard Material tab bar
  Widget _buildStandardTabBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: backgroundColor,
      padding: padding,
      child: TabBar(
        tabs: tabs.map((label) => Tab(text: label)).toList(),
        isScrollable: isScrollable,
        indicatorColor: indicatorColor ?? theme.tabBarTheme.indicatorColor,
        labelColor: labelColor ?? theme.tabBarTheme.labelColor,
        unselectedLabelColor:
            unselectedLabelColor ?? theme.tabBarTheme.unselectedLabelColor,
        indicatorWeight: indicatorWeight,
        labelStyle: theme.tabBarTheme.labelStyle,
        unselectedLabelStyle: theme.tabBarTheme.unselectedLabelStyle,
        tabAlignment: tabAlignment,
        onTap: onTap,
      ),
    );
  }

  /// Builds pill-style tab bar with rounded backgrounds
  Widget _buildPillsTabBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: backgroundColor,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = index == currentIndex;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Material(
                color: isSelected
                    ? (indicatorColor ?? colorScheme.primary)
                    : colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: () => onTap(index),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? null
                          : Border.all(color: colorScheme.outline),
                    ),
                    child: Text(
                      tabs[index],
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: isSelected
                            ? (labelColor ?? colorScheme.onPrimary)
                            : (unselectedLabelColor ?? colorScheme.onSurface),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  /// Builds segmented control style tab bar
  Widget _buildSegmentedTabBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: backgroundColor,
      padding: padding ?? const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = index == currentIndex;
            return Expanded(
              child: Material(
                color: isSelected ? colorScheme.surface : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () => onTap(index),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    child: Text(
                      tabs[index],
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: isSelected
                            ? (labelColor ?? colorScheme.onSurface)
                            : (unselectedLabelColor ??
                                  colorScheme.onSurfaceVariant),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  /// Builds minimal tab bar with subtle indicator
  Widget _buildMinimalTabBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: backgroundColor,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = index == currentIndex;
            return Padding(
              padding: const EdgeInsets.only(right: 24),
              child: InkWell(
                onTap: () => onTap(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        tabs[index],
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: isSelected
                              ? (labelColor ?? colorScheme.primary)
                              : (unselectedLabelColor ??
                                    colorScheme.onSurfaceVariant),
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: indicatorWeight,
                      width: isSelected ? 24 : 0,
                      decoration: BoxDecoration(
                        color: indicatorColor ?? colorScheme.primary,
                        borderRadius: BorderRadius.circular(
                          indicatorWeight / 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    double height = 48.0;

    if (variant == TabBarVariant.pills) {
      height = 56.0;
    } else if (variant == TabBarVariant.segmented) {
      height = 64.0;
    }

    if (padding != null) {
      final verticalPadding = padding!.vertical;
      height += verticalPadding;
    }

    return Size.fromHeight(height);
  }

  /// Factory constructor for day itinerary tabs
  factory CustomTabBar.dayItinerary({
    required List<String> days,
    required int currentDay,
    required ValueChanged<int> onDayChanged,
    TabBarVariant variant = TabBarVariant.pills,
  }) {
    return CustomTabBar(
      tabs: days,
      currentIndex: currentDay,
      onTap: onDayChanged,
      variant: variant,
      isScrollable: true,
    );
  }

  /// Factory constructor for trip filter tabs
  factory CustomTabBar.tripFilters({
    required BuildContext context,
    required int currentFilter,
    required ValueChanged<int> onFilterChanged,
  }) {
    final theme = Theme.of(context);

    return CustomTabBar(
      tabs: const ['All', 'Upcoming', 'Past', 'Favorites'],
      currentIndex: currentFilter,
      onTap: onFilterChanged,
      variant: TabBarVariant.segmented,
      backgroundColor: theme.colorScheme.surface,
    );
  }

  /// Factory constructor for place category tabs
  factory CustomTabBar.placeCategories({
    required BuildContext context,
    required int currentCategory,
    required ValueChanged<int> onCategoryChanged,
  }) {
    return CustomTabBar(
      tabs: const ['All', 'Restaurants', 'Attractions', 'Hotels', 'Activities'],
      currentIndex: currentCategory,
      onTap: onCategoryChanged,
      variant: TabBarVariant.minimal,
      isScrollable: true,
    );
  }

  /// Factory constructor for weather view tabs
  factory CustomTabBar.weatherViews({
    required BuildContext context,
    required int currentView,
    required ValueChanged<int> onViewChanged,
  }) {
    return CustomTabBar(
      tabs: const ['Today', 'Week', 'Details'],
      currentIndex: currentView,
      onTap: onViewChanged,
      variant: TabBarVariant.segmented,
    );
  }
}

/// Enum defining tab bar variants
enum TabBarVariant {
  /// Standard Material tab bar with underline indicator
  standard,

  /// Pill-style tabs with rounded backgrounds
  pills,

  /// Segmented control style with container
  segmented,

  /// Minimal tabs with subtle indicator
  minimal,
}
