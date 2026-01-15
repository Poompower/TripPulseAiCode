import 'package:flutter/material.dart';
import '../presentation/trip_list_screen/trip_list_screen.dart';
import '../presentation/trip_detail_screen/trip_detail_screen.dart';
import '../presentation/day_itinerary_screen/day_itinerary_screen.dart';
import '../presentation/create_trip_screen/create_trip_screen.dart';
import '../presentation/places_search_screen/places_search_screen.dart';
import '../presentation/place_detail_screen/place_detail_screen.dart';
import '../presentation/map_route_screen/map_route_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String tripList = '/trip-list-screen';
  static const String tripDetail = '/trip-detail-screen';
  static const String dayItinerary = '/day-itinerary-screen';
  static const String createTrip = '/create-trip-screen';
  static const String placesSearch = '/places-search-screen';
  static const String placeDetail = '/place-detail-screen';
  static const String mapRoute = '/map-route-screen';
  static const String generalMap = '/general-map-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const TripListScreen(),
    tripList: (context) => const TripListScreen(),
    tripDetail: (context) => const TripDetailScreen(),
    dayItinerary: (context) => const DayItineraryScreen(),
    createTrip: (context) => const CreateTripScreen(),
    placesSearch: (context) => const PlacesSearchScreen(),
    // TODO: Add your other routes here
  };
}
