import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/empty_state_widget.dart';
import './widgets/place_card_widget.dart';
import './widgets/route_summary_card_widget.dart';

/// Day Itinerary Screen - Manages places for specific trip days
/// Features: Drag-and-drop reordering, swipe actions, route summary
class DayItineraryScreen extends StatefulWidget {
  const DayItineraryScreen({super.key});

  @override
  State<DayItineraryScreen> createState() => _DayItineraryScreenState();
}

class _DayItineraryScreenState extends State<DayItineraryScreen> {
  int _currentBottomNavIndex = 0;
  bool _isLoading = false;
  bool _isRouteSummaryExpanded = true;

  // Mock data for places in the day itinerary
  final List<Map<String, dynamic>> _places = [
    {
      "id": "1",
      "name": "Eiffel Tower",
      "category": "landmark",
      "categoryIcon": "location_city",
      "description": "Iconic iron lattice tower on the Champ de Mars",
      "duration": "2-3 hours",
      "imageUrl":
          "https://images.unsplash.com/photo-1663935831493-8cc2295ffea4",
      "semanticLabel": "Eiffel Tower standing tall against blue sky in Paris",
      "coordinates": {"lat": 48.8584, "lng": 2.2945},
      "notes": "",
    },
    {
      "id": "2",
      "name": "Louvre Museum",
      "category": "museum",
      "categoryIcon": "museum",
      "description": "World's largest art museum and historic monument",
      "duration": "3-4 hours",
      "imageUrl":
          "https://images.unsplash.com/photo-1640684826122-6a4892722de2",
      "semanticLabel": "Glass pyramid entrance of the Louvre Museum in Paris",
      "coordinates": {"lat": 48.8606, "lng": 2.3376},
      "notes": "",
    },
    {
      "id": "3",
      "name": "Notre-Dame Cathedral",
      "category": "religious",
      "categoryIcon": "church",
      "description": "Medieval Catholic cathedral with Gothic architecture",
      "duration": "1-2 hours",
      "imageUrl":
          "https://images.unsplash.com/photo-1617870329369-a483be5ed173",
      "semanticLabel":
          "Notre-Dame Cathedral with its iconic twin towers and rose window",
      "coordinates": {"lat": 48.8530, "lng": 2.3499},
      "notes": "",
    },
    {
      "id": "4",
      "name": "Arc de Triomphe",
      "category": "landmark",
      "categoryIcon": "account_balance",
      "description": "Monumental arch honoring those who fought for France",
      "duration": "1 hour",
      "imageUrl":
          "https://images.unsplash.com/photo-1600708321238-c99be8eb1c00",
      "semanticLabel":
          "Arc de Triomphe monument at the center of Place Charles de Gaulle",
      "coordinates": {"lat": 48.8738, "lng": 2.2950},
      "notes": "",
    },
  ];

  // Mock route summary data
  final Map<String, dynamic> _routeSummary = {
    "totalDistance": "12.5 km",
    "estimatedTime": "45 mins",
    "transportMode": "walking",
    "lastUpdated": "2025-12-30T03:30:00Z",
  };

  @override
  void initState() {
    super.initState();
    _loadPlaceDetails();
  }

  Future<void> _loadPlaceDetails() async {
    setState(() => _isLoading = true);
    // Simulate API call to refresh place details
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  Future<void> _onRefresh() async {
    await _loadPlaceDetails();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _places.removeAt(oldIndex);
      _places.insert(newIndex, item);
    });

    // Provide haptic feedback
    // HapticFeedback.mediumImpact(); // Uncomment when implementing

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Place order updated'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Implement undo logic
          },
        ),
      ),
    );
  }

  void _removePlace(int index) {
    final removedPlace = _places[index];
    setState(() {
      _places.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removedPlace["name"]} removed'),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _places.insert(index, removedPlace);
            });
          },
        ),
      ),
    );
  }

  void _viewPlaceDetails(Map<String, dynamic> place) {
    // Navigate to place detail screen
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPlaceDetailsSheet(place),
    );
  }

  void _editPlaceNotes(Map<String, dynamic> place) {
    final TextEditingController notesController = TextEditingController(
      text: place["notes"] as String,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Notes'),
        content: TextField(
          controller: notesController,
          decoration: const InputDecoration(
            hintText: 'Add notes for this place...',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                place["notes"] = notesController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _getDirections(Map<String, dynamic> place) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening directions to ${place["name"]}...'),
        duration: const Duration(seconds: 2),
      ),
    );
    // Implement directions functionality
  }

  void _viewDayOnMap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening map view with all places...'),
        duration: Duration(seconds: 2),
      ),
    );
    // Navigate to map view with day-specific markers
  }

  Widget _buildPlaceDetailsSheet(Map<String, dynamic> place) {
    final theme = Theme.of(context);

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomImageWidget(
                      imageUrl: place["imageUrl"] as String,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      semanticLabel: place["semanticLabel"] as String,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    place["name"] as String,
                    style: theme.textTheme.headlineSmall,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: place["categoryIcon"] as String,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        (place["category"] as String).toUpperCase(),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const Spacer(),
                      CustomIconWidget(
                        iconName: 'schedule',
                        size: 20,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        place["duration"] as String,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    place["description"] as String,
                    style: theme.textTheme.bodyLarge,
                  ),
                  if ((place["notes"] as String).isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.3,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'note',
                                size: 20,
                                color: theme.colorScheme.primary,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Your Notes',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            place["notes"] as String,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _editPlaceNotes(place);
                          },
                          icon: CustomIconWidget(
                            iconName: 'edit',
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          label: const Text('Edit Notes'),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _getDirections(place);
                          },
                          icon: CustomIconWidget(
                            iconName: 'directions',
                            size: 20,
                            color: theme.colorScheme.onPrimary,
                          ),
                          label: const Text('Directions'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar.dayItinerary(
        context: context,
        dayLabel: 'Day 1 - December 30, 2025',
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'add_location_outlined',
              size: 24,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () =>
                Navigator.pushNamed(context, '/places-search-screen'),
            tooltip: 'Add place',
          ),
        ],
      ),
      body: _places.isEmpty
          ? EmptyStateWidget(
              onAddPlaces: () =>
                  Navigator.pushNamed(context, '/places-search-screen'),
            )
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: CustomScrollView(
                slivers: [
                  if (_isLoading)
                    SliverToBoxAdapter(
                      child: LinearProgressIndicator(
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: RouteSummaryCardWidget(
                        routeSummary: _routeSummary,
                        isExpanded: _isRouteSummaryExpanded,
                        onToggleExpanded: () {
                          setState(() {
                            _isRouteSummaryExpanded = !_isRouteSummaryExpanded;
                          });
                        },
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    sliver: SliverReorderableList(
                      itemCount: _places.length,
                      onReorder: _onReorder,
                      itemBuilder: (context, index) {
                        final place = _places[index];
                        return ReorderableDelayedDragStartListener(
                          key: ValueKey(place["id"]),
                          index: index,
                          child: Slidable(
                            key: ValueKey(place["id"]),
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) =>
                                      _viewPlaceDetails(place),
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: theme.colorScheme.onPrimary,
                                  icon: Icons.info_outline,
                                  label: 'Details',
                                ),
                                SlidableAction(
                                  onPressed: (context) =>
                                      _editPlaceNotes(place),
                                  backgroundColor: theme.colorScheme.secondary,
                                  foregroundColor:
                                      theme.colorScheme.onSecondary,
                                  icon: Icons.edit_note,
                                  label: 'Notes',
                                ),
                                SlidableAction(
                                  onPressed: (context) => _getDirections(place),
                                  backgroundColor: theme.colorScheme.tertiary,
                                  foregroundColor: theme.colorScheme.onTertiary,
                                  icon: Icons.directions,
                                  label: 'Directions',
                                ),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) => _removePlace(index),
                                  backgroundColor: theme.colorScheme.error,
                                  foregroundColor: theme.colorScheme.onError,
                                  icon: Icons.delete_outline,
                                  label: 'Remove',
                                ),
                              ],
                            ),
                            child: PlaceCardWidget(
                              place: place,
                              onTap: () => _viewPlaceDetails(place),
                              onLongPress: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) =>
                                      _buildContextMenu(place, index),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 10.h)),
                ],
              ),
            ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() => _currentBottomNavIndex = index);
          CustomBottomBar.navigateToIndex(context, index);
        },
        variant: BottomBarVariant.material3,
      ),
      floatingActionButton: _places.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _viewDayOnMap,
              icon: CustomIconWidget(
                iconName: 'map',
                size: 24,
                color: theme.colorScheme.onPrimary,
              ),
              label: const Text('View Day on Map'),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildContextMenu(Map<String, dynamic> place, int index) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: CustomIconWidget(
              iconName: 'info_outline',
              size: 24,
              color: theme.colorScheme.primary,
            ),
            title: const Text('View Details'),
            onTap: () {
              Navigator.pop(context);
              _viewPlaceDetails(place);
            },
          ),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'edit_note',
              size: 24,
              color: theme.colorScheme.secondary,
            ),
            title: const Text('Edit Notes'),
            onTap: () {
              Navigator.pop(context);
              _editPlaceNotes(place);
            },
          ),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'directions',
              size: 24,
              color: theme.colorScheme.tertiary,
            ),
            title: const Text('Get Directions'),
            onTap: () {
              Navigator.pop(context);
              _getDirections(place);
            },
          ),
          const Divider(),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'delete_outline',
              size: 24,
              color: theme.colorScheme.error,
            ),
            title: Text(
              'Remove from Day',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: () {
              Navigator.pop(context);
              _removePlace(index);
            },
          ),
        ],
      ),
    );
  }
}
