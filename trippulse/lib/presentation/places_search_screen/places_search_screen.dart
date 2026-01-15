import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../routes/app_routes.dart';
import './widgets/category_filter_chips_widget.dart';
import './widgets/day_selector_bottom_sheet_widget.dart';
import './widgets/empty_search_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/place_card_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/skeleton_place_card_widget.dart';

class PlacesSearchScreen extends StatefulWidget {
  const PlacesSearchScreen({super.key});

  @override
  State<PlacesSearchScreen> createState() => _PlacesSearchScreenState();
}

class _PlacesSearchScreenState extends State<PlacesSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedCategories = {};
  bool _isLoading = false;
  bool _isRefreshing = false;
  String _searchQuery = '';
  int _currentBottomNavIndex = 1; // Search tab

  // Mock destination
  final String _destination = 'Paris';

  // Mock categories with counts
  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'count': 48},
    {'name': 'Museums', 'count': 12},
    {'name': 'Restaurants', 'count': 18},
    {'name': 'Parks', 'count': 8},
    {'name': 'Historic Sites', 'count': 10},
  ];

  // Mock places data
  final List<Map<String, dynamic>> _allPlaces = [
    {
      'id': 1,
      'name': 'Louvre Museum',
      'category': 'Museums',
      'rating': 4.8,
      'distance': '2.3 km from center',
      'description':
          'World\'s largest art museum and historic monument in Paris',
      'image':
          'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?w=400',
      'semanticLabel':
          'Iconic glass pyramid entrance of the Louvre Museum in Paris with classical architecture in background',
      'coordinates': {'lat': 48.8606, 'lng': 2.3376},
    },
    {
      'id': 2,
      'name': 'Eiffel Tower',
      'category': 'Historic Sites',
      'rating': 4.9,
      'distance': '3.1 km from center',
      'description':
          'Iconic iron lattice tower and global cultural icon of France',
      'image': 'https://images.unsplash.com/photo-1514562514633-f56a2f7c58d5',
      'semanticLabel':
          'Eiffel Tower standing tall against blue sky with Champ de Mars gardens in foreground',
      'coordinates': {'lat': 48.8584, 'lng': 2.2945},
    },
    {
      'id': 3,
      'name': 'Le Jules Verne',
      'category': 'Restaurants',
      'rating': 4.7,
      'distance': '3.1 km from center',
      'description': 'Michelin-starred restaurant located on the Eiffel Tower',
      'image': 'https://images.unsplash.com/photo-1560130934-590b85fc08e7',
      'semanticLabel':
          'Elegant fine dining restaurant interior with white tablecloths and ambient lighting',
      'coordinates': {'lat': 48.8583, 'lng': 2.2945},
    },
    {
      'id': 4,
      'name': 'Luxembourg Gardens',
      'category': 'Parks',
      'rating': 4.6,
      'distance': '1.8 km from center',
      'description': 'Beautiful public park with formal gardens and palace',
      'image': 'https://images.unsplash.com/photo-1644910464326-ace446f59dd2',
      'semanticLabel':
          'Lush green Luxembourg Gardens with manicured lawns, trees, and palace building in background',
      'coordinates': {'lat': 48.8462, 'lng': 2.3372},
    },
    {
      'id': 5,
      'name': 'Notre-Dame Cathedral',
      'category': 'Historic Sites',
      'rating': 4.8,
      'distance': '1.2 km from center',
      'description': 'Medieval Catholic cathedral with Gothic architecture',
      'image': 'https://images.unsplash.com/photo-1617870329369-a483be5ed173',
      'semanticLabel':
          'Notre-Dame Cathedral facade with twin towers and rose window in Gothic architectural style',
      'coordinates': {'lat': 48.8530, 'lng': 2.3499},
    },
    {
      'id': 6,
      'name': 'Musée d\'Orsay',
      'category': 'Museums',
      'rating': 4.7,
      'distance': '2.5 km from center',
      'description': 'Museum housing French art from 1848 to 1914',
      'image':
          'https://images.unsplash.com/photo-1566127444979-b3d2b654e3d7?w=400',
      'semanticLabel':
          'Musée d\'Orsay building exterior with Beaux-Arts architecture along the Seine River',
      'coordinates': {'lat': 48.8600, 'lng': 2.3266},
    },
    {
      'id': 7,
      'name': 'Café de Flore',
      'category': 'Restaurants',
      'rating': 4.5,
      'distance': '2.0 km from center',
      'description': 'Historic café frequented by famous writers and artists',
      'image': 'https://images.unsplash.com/photo-1603020500697-1bf30af0d368',
      'semanticLabel':
          'Classic Parisian café exterior with red awning and outdoor seating on cobblestone street',
      'coordinates': {'lat': 48.8542, 'lng': 2.3320},
    },
    {
      'id': 8,
      'name': 'Tuileries Garden',
      'category': 'Parks',
      'rating': 4.6,
      'distance': '2.1 km from center',
      'description': 'Public garden between Louvre and Place de la Concorde',
      'image':
          'https://img.rocket.new/generatedImages/rocket_gen_img_123880e3b-1767065993203.png',
      'semanticLabel':
          'Tuileries Garden with tree-lined pathways, fountains, and sculptures',
      'coordinates': {'lat': 48.8634, 'lng': 2.3275},
    },
  ];

  // Mock trip days for day selector
  final List<Map<String, dynamic>> _tripDays = [
    {'title': 'Day 1 - Arrival & City Center', 'placeCount': 3},
    {'title': 'Day 2 - Museums & Culture', 'placeCount': 5},
    {'title': 'Day 3 - Parks & Gardens', 'placeCount': 2},
    {'title': 'Day 4 - Historic Sites', 'placeCount': 4},
    {'title': 'Day 5 - Departure', 'placeCount': 1},
  ];

  List<Map<String, dynamic>> _filteredPlaces = [];

  @override
  void initState() {
    super.initState();
    _filteredPlaces = List.from(_allPlaces);
    _simulateInitialLoad();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _simulateInitialLoad() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterPlaces();
    });
  }

  void _filterPlaces() {
    setState(() {
      _filteredPlaces = _allPlaces.where((place) {
        final matchesSearch =
            _searchQuery.isEmpty ||
            (place['name'] as String).toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            (place['description'] as String).toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );

        final matchesCategory =
            _selectedCategories.isEmpty ||
            _selectedCategories.contains('All') ||
            _selectedCategories.contains(place['category']);

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _onCategoryToggle(String category) {
    setState(() {
      if (category == 'All') {
        _selectedCategories.clear();
      } else {
        _selectedCategories.remove('All');
        if (_selectedCategories.contains(category)) {
          _selectedCategories.remove(category);
        } else {
          _selectedCategories.add(category);
        }
      }
      _filterPlaces();
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterBottomSheetWidget(
        selectedCategories: _selectedCategories,
        onApplyFilters: (categories) {
          setState(() {
            _selectedCategories.clear();
            _selectedCategories.addAll(categories);
            _filterPlaces();
          });
        },
      ),
    );
  }

  void _showDaySelectorBottomSheet(Map<String, dynamic> place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DaySelectorBottomSheetWidget(
        placeName: place['name'] as String,
        tripDays: _tripDays,
        onDaySelected: (dayIndex) {
          _addPlaceToDay(place, dayIndex);
        },
      ),
    );
  }

  void _addPlaceToDay(Map<String, dynamic> place, int dayIndex) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${place['name']} added to Day ${dayIndex + 1}'),
        backgroundColor: theme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View',
          textColor: theme.colorScheme.onPrimary,
          onPressed: () {
            Navigator.pushNamed(context, '/day-itinerary-screen');
          },
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
        _filteredPlaces = List.from(_allPlaces);
      });
    }
  }

  void _onPlaceCardTap(Map<String, dynamic> place) {
    // Navigate to place detail screen
    Navigator.pushNamed(
      context,
      AppRoutes.placeDetail,
      arguments: {
        'placeId': place['id'].toString(),
        'placeName': place['name'],
        'placeData': place,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar.placesSearch(context: context),
      body: Column(
        children: [
          // Search bar
          SearchBarWidget(
            destination: _destination,
            controller: _searchController,
            onChanged: _onSearchChanged,
            onFilterTap: _showFilterBottomSheet,
            hasActiveFilters: _selectedCategories.isNotEmpty,
          ),

          // Category filter chips
          if (_selectedCategories.isNotEmpty || _searchQuery.isNotEmpty)
            CategoryFilterChipsWidget(
              categories: _categories,
              selectedCategories: _selectedCategories,
              onCategoryToggle: _onCategoryToggle,
            ),

          // Results list
          Expanded(child: _buildResultsList()),
        ],
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
    );
  }

  Widget _buildResultsList() {
    if (_isLoading) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        itemCount: 5,
        itemBuilder: (context, index) => const SkeletonPlaceCardWidget(),
      );
    }

    if (_filteredPlaces.isEmpty) {
      return EmptySearchStateWidget(
        searchQuery: _searchQuery,
        onClearSearch: () {
          _searchController.clear();
          _onSearchChanged('');
        },
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        itemCount: _filteredPlaces.length,
        itemBuilder: (context, index) {
          final place = _filteredPlaces[index];
          return PlaceCardWidget(
            place: place,
            onTap: () => _onPlaceCardTap(place),
            onAddToDay: () => _showDaySelectorBottomSheet(place),
          );
        },
      ),
    );
  }
}
