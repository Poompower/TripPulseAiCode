import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/trip_card_widget.dart';

/// Trip List Screen - Primary home screen displaying all user trips
/// Implements pull-to-refresh, swipe actions, and search functionality
class TripListScreen extends StatefulWidget {
  const TripListScreen({super.key});

  @override
  State<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isSearchVisible = false;
  String _searchQuery = '';
  bool _isRefreshing = false;

  // Mock trip data with comprehensive details
  final List<Map<String, dynamic>> _trips = [
    {
      "id": "1",
      "title": "Summer in Paris",
      "destination": "Paris, France",
      "startDate": DateTime(2025, 7, 15),
      "endDate": DateTime(2025, 7, 22),
      "weatherIcon": "wb_sunny",
      "temperature": "28°C",
      "imageUrl":
          "https://images.unsplash.com/photo-1685460930241-a9450a4b6ffc",
      "semanticLabel":
          "Eiffel Tower at sunset with pink and orange sky over Paris cityscape",
      "isFavorite": true,
      "currency": "EUR",
      "budget": "\$2,500",
    },
    {
      "id": "2",
      "title": "Tokyo Adventure",
      "destination": "Tokyo, Japan",
      "startDate": DateTime(2025, 9, 10),
      "endDate": DateTime(2025, 9, 18),
      "weatherIcon": "cloud",
      "temperature": "22°C",
      "imageUrl":
          "https://images.unsplash.com/photo-1633950440734-cec528030d58",
      "semanticLabel":
          "Tokyo cityscape at night with illuminated skyscrapers and neon lights",
      "isFavorite": false,
      "currency": "JPY",
      "budget": "\$3,200",
    },
    {
      "id": "3",
      "title": "Bali Retreat",
      "destination": "Bali, Indonesia",
      "startDate": DateTime(2025, 11, 5),
      "endDate": DateTime(2025, 11, 12),
      "weatherIcon": "wb_cloudy",
      "temperature": "30°C",
      "imageUrl":
          "https://images.unsplash.com/photo-1718370767111-366b47667494",
      "semanticLabel":
          "Traditional Balinese temple with stone architecture surrounded by lush tropical greenery",
      "isFavorite": true,
      "currency": "IDR",
      "budget": "\$1,800",
    },
    {
      "id": "4",
      "title": "New York City Break",
      "destination": "New York, USA",
      "startDate": DateTime(2025, 12, 20),
      "endDate": DateTime(2025, 12, 27),
      "weatherIcon": "ac_unit",
      "temperature": "5°C",
      "imageUrl":
          "https://images.unsplash.com/photo-1601572522457-db29f30ca5fb",
      "semanticLabel":
          "Manhattan skyline with Empire State Building and modern skyscrapers against blue sky",
      "isFavorite": false,
      "currency": "USD",
      "budget": "\$4,000",
    },
    {
      "id": "5",
      "title": "Swiss Alps Skiing",
      "destination": "Zermatt, Switzerland",
      "startDate": DateTime(2026, 1, 15),
      "endDate": DateTime(2026, 1, 22),
      "weatherIcon": "ac_unit",
      "temperature": "-2°C",
      "imageUrl":
          "https://images.unsplash.com/photo-1704236041862-f581ce5b9bbe",
      "semanticLabel":
          "Snow-covered mountain peaks of the Swiss Alps with ski slopes and pine trees",
      "isFavorite": true,
      "currency": "CHF",
      "budget": "\$5,500",
    },
    {
      "id": "6",
      "title": "Barcelona Culture Tour",
      "destination": "Barcelona, Spain",
      "startDate": DateTime(2026, 3, 10),
      "endDate": DateTime(2026, 3, 17),
      "weatherIcon": "wb_sunny",
      "temperature": "18°C",
      "imageUrl":
          "https://images.unsplash.com/photo-1728300940728-b371aad7c9f7",
      "semanticLabel":
          "Sagrada Familia cathedral with ornate Gothic spires against clear blue sky in Barcelona",
      "isFavorite": false,
      "currency": "EUR",
      "budget": "\$2,200",
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.offset > 100 && !_isSearchVisible) {
      setState(() => _isSearchVisible = true);
    } else if (_scrollController.offset <= 100 && _isSearchVisible) {
      setState(() => _isSearchVisible = false);
    }
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);

    // Simulate API call for weather and currency sync
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isRefreshing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trips updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleSearch(String query) {
    setState(() => _searchQuery = query.toLowerCase());
  }

  List<Map<String, dynamic>> _getFilteredTrips() {
    if (_searchQuery.isEmpty) return _trips;

    return _trips.where((trip) {
      final title = (trip['title'] as String).toLowerCase();
      final destination = (trip['destination'] as String).toLowerCase();
      return title.contains(_searchQuery) || destination.contains(_searchQuery);
    }).toList();
  }

  void _handleTripTap(Map<String, dynamic> trip) {
    Navigator.pushNamed(context, '/trip-detail-screen', arguments: trip);
  }

  void _handleEditTrip(Map<String, dynamic> trip) {
    Navigator.pushNamed(
      context,
      '/create-trip-screen',
      arguments: {'mode': 'edit', 'trip': trip},
    );
  }

  void _handleDuplicateTrip(Map<String, dynamic> trip) {
    setState(() {
      final newTrip = Map<String, dynamic>.from(trip);
      newTrip['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      newTrip['title'] = '${trip['title']} (Copy)';
      _trips.insert(0, newTrip);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Trip duplicated successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleShareTrip(Map<String, dynamic> trip) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${trip['title']}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleDeleteTrip(Map<String, dynamic> trip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip'),
        content: Text('Are you sure you want to delete "${trip['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _trips.removeWhere((t) => t['id'] == trip['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Trip deleted successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _handleToggleFavorite(Map<String, dynamic> trip) {
    setState(() {
      trip['isFavorite'] = !(trip['isFavorite'] as bool);
    });
  }

  void _handleCreateTrip() {
    Navigator.pushNamed(context, '/create-trip-screen');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredTrips = _getFilteredTrips();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 2,
        title: Text(
          'My Trips',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'add',
              color: theme.colorScheme.primary,
              size: 28,
            ),
            onPressed: _handleCreateTrip,
            tooltip: 'Create new trip',
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar (visible on scroll)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isSearchVisible ? 10.h : 0,
              child: _isSearchVisible
                  ? SearchBarWidget(
                      onSearch: _handleSearch,
                      searchQuery: _searchQuery,
                    )
                  : const SizedBox.shrink(),
            ),

            // Trip list or empty state
            Expanded(
              child: filteredTrips.isEmpty
                  ? EmptyStateWidget(
                      onCreateTrip: _handleCreateTrip,
                      isSearchActive: _searchQuery.isNotEmpty,
                    )
                  : RefreshIndicator(
                      onRefresh: _handleRefresh,
                      color: theme.colorScheme.primary,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 2.h,
                        ),
                        itemCount: filteredTrips.length,
                        itemBuilder: (context, index) {
                          final trip = filteredTrips[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: TripCardWidget(
                              trip: trip,
                              onTap: () => _handleTripTap(trip),
                              onEdit: () => _handleEditTrip(trip),
                              onDuplicate: () => _handleDuplicateTrip(trip),
                              onShare: () => _handleShareTrip(trip),
                              onDelete: () => _handleDeleteTrip(trip),
                              onToggleFavorite: () =>
                                  _handleToggleFavorite(trip),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 0,
        onTap: (index) {
          if (index != 0) {
            CustomBottomBar.navigateToIndex(context, index);
          }
        },
        variant: BottomBarVariant.material3,
        showLabels: true,
      ),
      floatingActionButton: MediaQuery.of(context).size.width < 600
          ? FloatingActionButton(
              onPressed: _handleCreateTrip,
              tooltip: 'Create new trip',
              child: CustomIconWidget(
                iconName: 'add',
                color: theme.colorScheme.onPrimary,
                size: 28,
              ),
            )
          : null,
    );
  }
}
