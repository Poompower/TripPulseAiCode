import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom app bar for TripPulse application
/// Implements clean, minimal design with platform-aware patterns
/// Supports various configurations for different screen contexts
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Title text or widget
  final dynamic title;

  /// Leading widget (typically back button or menu)
  final Widget? leading;

  /// Actions widgets (typically icons)
  final List<Widget>? actions;

  /// Whether to show back button automatically
  final bool automaticallyImplyLeading;

  /// App bar variant
  final AppBarVariant variant;

  /// Custom background color (optional, uses theme if null)
  final Color? backgroundColor;

  /// Custom foreground color for text and icons (optional, uses theme if null)
  final Color? foregroundColor;

  /// Elevation of the app bar
  final double elevation;

  /// Whether the app bar should have a shadow when scrolled
  final double scrolledUnderElevation;

  /// Center the title
  final bool centerTitle;

  /// Bottom widget (typically TabBar)
  final PreferredSizeWidget? bottom;

  /// Flexible space widget (for collapsing toolbars)
  final Widget? flexibleSpace;

  /// System overlay style for status bar
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Custom height (optional, uses default if null)
  final double? toolbarHeight;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.variant = AppBarVariant.standard,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.scrolledUnderElevation = 2,
    this.centerTitle = false,
    this.bottom,
    this.flexibleSpace,
    this.systemOverlayStyle,
    this.toolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case AppBarVariant.standard:
        return _buildStandardAppBar(context);
      case AppBarVariant.large:
        return _buildLargeAppBar(context);
      case AppBarVariant.medium:
        return _buildMediumAppBar(context);
      case AppBarVariant.transparent:
        return _buildTransparentAppBar(context);
      case AppBarVariant.search:
        return _buildSearchAppBar(context);
    }
  }

  /// Builds standard app bar
  Widget _buildStandardAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: _buildTitle(context),
      leading: leading,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      centerTitle: centerTitle,
      bottom: bottom,
      flexibleSpace: flexibleSpace,
      systemOverlayStyle: systemOverlayStyle ?? _getSystemOverlayStyle(context),
      toolbarHeight: toolbarHeight,
    );
  }

  /// Builds large app bar with prominent title
  Widget _buildLargeAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      title: _buildTitle(context),
      leading: leading,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      centerTitle: centerTitle,
      pinned: true,
      expandedHeight: 120,
      flexibleSpace:
          flexibleSpace ??
          FlexibleSpaceBar(
            title: _buildTitle(context, isLarge: true),
            titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
          ),
      systemOverlayStyle: systemOverlayStyle ?? _getSystemOverlayStyle(context),
    );
  }

  /// Builds medium app bar
  Widget _buildMediumAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      title: _buildTitle(context),
      leading: leading,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      centerTitle: centerTitle,
      pinned: true,
      expandedHeight: 96,
      flexibleSpace: flexibleSpace,
      systemOverlayStyle: systemOverlayStyle ?? _getSystemOverlayStyle(context),
    );
  }

  /// Builds transparent app bar (for overlays)
  Widget _buildTransparentAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: _buildTitle(context),
      leading: leading,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: Colors.transparent,
      foregroundColor: foregroundColor ?? theme.colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      bottom: bottom,
      flexibleSpace: flexibleSpace,
      systemOverlayStyle: systemOverlayStyle ?? SystemUiOverlayStyle.light,
      toolbarHeight: toolbarHeight,
    );
  }

  /// Builds search-focused app bar
  Widget _buildSearchAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: _buildSearchField(context),
      leading:
          leading ??
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
      actions: actions,
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      centerTitle: false,
      systemOverlayStyle: systemOverlayStyle ?? _getSystemOverlayStyle(context),
      toolbarHeight: toolbarHeight,
    );
  }

  /// Builds title widget
  Widget _buildTitle(BuildContext context, {bool isLarge = false}) {
    if (title is Widget) {
      return title as Widget;
    }

    final theme = Theme.of(context);
    final textStyle = isLarge
        ? theme.textTheme.headlineSmall
        : theme.appBarTheme.titleTextStyle;

    return Text(title.toString(), style: textStyle);
  }

  /// Builds search field for search variant
  Widget _buildSearchField(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search places...',
        border: InputBorder.none,
        hintStyle: theme.inputDecorationTheme.hintStyle,
      ),
      style: theme.textTheme.bodyLarge,
    );
  }

  /// Gets appropriate system overlay style based on theme
  SystemUiOverlayStyle _getSystemOverlayStyle(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return brightness == Brightness.light
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light;
  }

  @override
  Size get preferredSize {
    double height = toolbarHeight ?? kToolbarHeight;

    if (bottom != null) {
      height += bottom!.preferredSize.height;
    }

    if (variant == AppBarVariant.large) {
      height = 120;
    } else if (variant == AppBarVariant.medium) {
      height = 96;
    }

    return Size.fromHeight(height);
  }

  /// Factory constructor for trip list screen
  factory CustomAppBar.tripList({
    required BuildContext context,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      title: 'My Trips',
      variant: AppBarVariant.large,
      actions:
          actions ??
          [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () =>
                  Navigator.pushNamed(context, '/create-trip-screen'),
              tooltip: 'Create new trip',
            ),
          ],
    );
  }

  /// Factory constructor for trip detail screen
  factory CustomAppBar.tripDetail({
    required BuildContext context,
    required String tripName,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      title: tripName,
      variant: AppBarVariant.standard,
      actions:
          actions ??
          [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                // Edit trip action
              },
              tooltip: 'Edit trip',
            ),
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () {
                // Share trip action
              },
              tooltip: 'Share trip',
            ),
          ],
    );
  }

  /// Factory constructor for day itinerary screen
  factory CustomAppBar.dayItinerary({
    required BuildContext context,
    required String dayLabel,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      title: dayLabel,
      variant: AppBarVariant.standard,
      actions:
          actions ??
          [
            IconButton(
              icon: const Icon(Icons.add_location_outlined),
              onPressed: () =>
                  Navigator.pushNamed(context, '/places-search-screen'),
              tooltip: 'Add place',
            ),
          ],
    );
  }

  /// Factory constructor for places search screen
  factory CustomAppBar.placesSearch({
    required BuildContext context,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      title: 'Search Places',
      variant: AppBarVariant.search,
      actions: actions,
    );
  }

  /// Factory constructor for create trip screen
  factory CustomAppBar.createTrip({required BuildContext context}) {
    return const CustomAppBar(
      title: 'Create Trip',
      variant: AppBarVariant.standard,
      centerTitle: true,
    );
  }
}

/// Enum defining app bar variants
enum AppBarVariant {
  /// Standard height app bar
  standard,

  /// Large app bar with prominent title
  large,

  /// Medium height app bar
  medium,

  /// Transparent app bar for overlays
  transparent,

  /// Search-focused app bar with text field
  search,
}
