import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/budget_summary_placeholder.dart';
import './widgets/empty_itinerary_state.dart';
import './widgets/itinerary_day_card.dart';
import './widgets/weather_forecast_card.dart';

/// Trip Detail Screen - Comprehensive trip overview with weather and itinerary
/// Displays trip information, 5-day weather forecast, and day-by-day itinerary
class TripDetailScreen extends StatefulWidget {
  const TripDetailScreen({super.key});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  int _currentBottomNavIndex = 0;
  bool _isLoading = false;
  bool _isOffline = false;
  DateTime _lastUpdated = DateTime.now();

  // Mock trip data
  final Map<String, dynamic> _tripData = {
    "id": "trip_001",
    "title": "Tokyo Adventure",
    "destination": "Tokyo, Japan",
    "startDate": DateTime(2025, 3, 15),
    "endDate": DateTime(2025, 3, 22),
    "baseCurrency": "USD",
    "coverImage":
        "https://images.unsplash.com/photo-1669521355191-6015377895d1",
    "coverImageLabel":
        "Aerial view of Tokyo cityscape at sunset with Mount Fuji in the background, showing dense urban development and modern skyscrapers",
  };

  // Mock weather data (5-day forecast)
  final List<Map<String, dynamic>> _weatherForecast = [
    {
      "date": DateTime(2025, 3, 15),
      "dayOfWeek": "Sat",
      "condition": "Sunny",
      "icon": "wb_sunny",
      "tempHigh": 18,
      "tempLow": 12,
      "precipitation": 10,
      "humidity": 65,
    },
    {
      "date": DateTime(2025, 3, 16),
      "dayOfWeek": "Sun",
      "condition": "Partly Cloudy",
      "icon": "wb_cloudy",
      "tempHigh": 16,
      "tempLow": 11,
      "precipitation": 20,
      "humidity": 70,
    },
    {
      "date": DateTime(2025, 3, 17),
      "dayOfWeek": "Mon",
      "condition": "Rainy",
      "icon": "water_drop",
      "tempHigh": 14,
      "tempLow": 10,
      "precipitation": 80,
      "humidity": 85,
    },
    {
      "date": DateTime(2025, 3, 18),
      "dayOfWeek": "Tue",
      "condition": "Cloudy",
      "icon": "cloud",
      "tempHigh": 15,
      "tempLow": 9,
      "precipitation": 30,
      "humidity": 75,
    },
    {
      "date": DateTime(2025, 3, 19),
      "dayOfWeek": "Wed",
      "condition": "Sunny",
      "icon": "wb_sunny",
      "tempHigh": 19,
      "tempLow": 13,
      "precipitation": 5,
      "humidity": 60,
    },
  ];

  // Mock itinerary days
  final List<Map<String, dynamic>> _itineraryDays = [
    {
      "dayNumber": 1,
      "date": DateTime(2025, 3, 15),
      "dayOfWeek": "Saturday",
      "places": [
        {
          "name": "Senso-ji Temple",
          "category": "Attraction",
          "image":
              "https://images.unsplash.com/photo-1687251137351-a03ba861e1ff",
          "imageLabel":
              "Traditional red Japanese temple gate with large lantern at Senso-ji Temple in Tokyo",
        },
        {
          "name": "Tokyo Skytree",
          "category": "Attraction",
          "image":
              "https://images.unsplash.com/photo-1702042895765-c545f807a10c",
          "imageLabel":
              "Tokyo Skytree tower illuminated at night against dark blue sky",
        },
        {
          "name": "Tsukiji Outer Market",
          "category": "Restaurant",
          "image":
              "https://images.unsplash.com/photo-1614807186821-6b933182665c",
          "imageLabel":
              "Fresh sushi and seafood display at Tsukiji fish market with various colorful ingredients",
        },
      ],
    },
    {
      "dayNumber": 2,
      "date": DateTime(2025, 3, 16),
      "dayOfWeek": "Sunday",
      "places": [
        {
          "name": "Meiji Shrine",
          "category": "Attraction",
          "image":
              "https://images.unsplash.com/photo-1685355118838-86a831b3ec6c",
          "imageLabel":
              "Traditional wooden Shinto shrine entrance surrounded by tall green trees in peaceful forest setting",
        },
        {
          "name": "Harajuku Takeshita Street",
          "category": "Shopping",
          "image":
              "https://images.unsplash.com/photo-1588080189364-5ccfb51b9a6b",
          "imageLabel":
              "Busy pedestrian street in Harajuku with colorful shops and crowds of young people",
        },
      ],
    },
    {
      "dayNumber": 3,
      "date": DateTime(2025, 3, 17),
      "dayOfWeek": "Monday",
      "places": [
        {
          "name": "teamLab Borderless",
          "category": "Attraction",
          "image":
              "https://images.unsplash.com/photo-1593073862407-a3ce22748763",
          "imageLabel":
              "Immersive digital art installation with colorful projected lights and interactive displays",
        },
      ],
    },
    {
      "dayNumber": 4,
      "date": DateTime(2025, 3, 18),
      "dayOfWeek": "Tuesday",
      "places": [],
    },
    {
      "dayNumber": 5,
      "date": DateTime(2025, 3, 19),
      "dayOfWeek": "Wednesday",
      "places": [
        {
          "name": "Mount Fuji Day Trip",
          "category": "Activity",
          "image":
              "https://images.unsplash.com/photo-1713376051619-71aca5aaa2ac",
          "imageLabel":
              "Majestic Mount Fuji with snow-capped peak against clear blue sky with cherry blossoms in foreground",
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    // Simulate connectivity check
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isOffline = false;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call to refresh weather and currency data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _lastUpdated = DateTime.now();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Trip data updated successfully'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void _navigateToDayItinerary(int dayNumber) {
    Navigator.pushNamed(
      context,
      '/day-itinerary-screen',
      arguments: {
        'tripId': _tripData['id'],
        'dayNumber': dayNumber,
        'date': _itineraryDays[dayNumber - 1]['date'],
      },
    );
  }

  void _navigateToMap() {
    // Navigate to map view for entire trip
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Map view coming soon'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _editTrip() {
    Navigator.pushNamed(
      context,
      '/create-trip-screen',
      arguments: {'tripId': _tripData['id'], 'isEdit': true},
    );
  }

  void _shareTrip() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Share functionality coming soon'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showDayQuickActions(BuildContext context, int dayNumber) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.4,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text('Day $dayNumber Actions', style: theme.textTheme.titleLarge),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'add_location',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Add Place', style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/places-search-screen');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'map',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              title: Text('View on Map', style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                _navigateToMap();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'reorder',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Reorder Days', style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Reorder functionality coming soon'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasPlaces = _itineraryDays.any(
      (day) => (day['places'] as List).isNotEmpty,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar.tripDetail(
        context: context,
        tripName: _tripData['title'] as String,
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'edit_outlined',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: _editTrip,
            tooltip: 'Edit trip',
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'share_outlined',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: _shareTrip,
            tooltip: 'Share trip',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: CustomScrollView(
          slivers: [
            // Trip cover image
            SliverToBoxAdapter(
              child: CustomImageWidget(
                imageUrl: _tripData['coverImage'] as String,
                width: 100.w,
                height: 25.h,
                fit: BoxFit.cover,
                semanticLabel: _tripData['coverImageLabel'] as String,
              ),
            ),

            // Trip info section
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            _tripData['destination'] as String,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'calendar_today',
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${(_tripData['startDate'] as DateTime).month}/${(_tripData['startDate'] as DateTime).day}/${(_tripData['startDate'] as DateTime).year} - ${(_tripData['endDate'] as DateTime).month}/${(_tripData['endDate'] as DateTime).day}/${(_tripData['endDate'] as DateTime).year}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    if (_isOffline) ...[
                      SizedBox(height: 1.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'cloud_off',
                              color: theme.colorScheme.onErrorContainer,
                              size: 16,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Offline - Last updated ${_lastUpdated.hour}:${_lastUpdated.minute.toString().padLeft(2, '0')}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onErrorContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Weather forecast card (sticky)
            SliverToBoxAdapter(
              child: WeatherForecastCard(
                weatherData: _weatherForecast,
                isLoading: _isLoading,
                lastUpdated: _lastUpdated,
              ),
            ),

            // Budget summary placeholder
            SliverToBoxAdapter(
              child: BudgetSummaryPlaceholder(
                baseCurrency: _tripData['baseCurrency'] as String,
              ),
            ),

            // Itinerary section header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(4.w, 3.h, 4.w, 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Itinerary',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (hasPlaces)
                      TextButton.icon(
                        onPressed: _navigateToMap,
                        icon: CustomIconWidget(
                          iconName: 'map',
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        label: Text(
                          'View All',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Itinerary days or empty state
            if (!hasPlaces)
              SliverToBoxAdapter(
                child: EmptyItineraryState(
                  onStartPlanning: () {
                    Navigator.pushNamed(context, '/places-search-screen');
                  },
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final day = _itineraryDays[index];
                  return ItineraryDayCard(
                    dayNumber: day['dayNumber'] as int,
                    date: day['date'] as DateTime,
                    dayOfWeek: day['dayOfWeek'] as String,
                    places: day['places'] as List<Map<String, dynamic>>,
                    onTap: () =>
                        _navigateToDayItinerary(day['dayNumber'] as int),
                    onLongPress: () =>
                        _showDayQuickActions(context, day['dayNumber'] as int),
                    onAddPlace: () {
                      Navigator.pushNamed(context, '/places-search-screen');
                    },
                  );
                }, childCount: _itineraryDays.length),
              ),

            // Bottom spacing
            SliverToBoxAdapter(child: SizedBox(height: 10.h)),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
          CustomBottomBar.navigateToIndex(context, index);
        },
        variant: BottomBarVariant.material3,
      ),
      floatingActionButton: hasPlaces
          ? FloatingActionButton.extended(
              onPressed: _navigateToMap,
              icon: CustomIconWidget(
                iconName: 'map',
                color: theme.colorScheme.onPrimary,
                size: 24,
              ),
              label: Text(
                'View on Map',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            )
          : null,
    );
  }
}
