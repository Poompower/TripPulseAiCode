import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import '../widgets/custom_error_widget.dart';
import '../presentation/trip_list_screen/trip_list_screen.dart';
import '../presentation/trip_detail_screen/trip_detail_screen.dart';
import '../presentation/day_itinerary_screen/day_itinerary_screen.dart';
import '../presentation/create_trip_screen/create_trip_screen.dart';
import '../presentation/places_search_screen/places_search_screen.dart';
import '../presentation/place_detail_screen/place_detail_screen.dart';
import '../presentation/map_route_screen/map_route_screen.dart';
import '../presentation/general_map_screen/general_map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool _hasShownError = false;

  // 🚨 CRITICAL: Custom error handling - DO NOT REMOVE
  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (!_hasShownError) {
      _hasShownError = true;

      // Reset flag after 3 seconds to allow error widget on new screens
      Future.delayed(Duration(seconds: 5), () {
        _hasShownError = false;
      });

      return CustomErrorWidget(errorDetails: details);
    }
    return SizedBox.shrink();
  };

  // 🚨 CRITICAL: Device orientation lock - DO NOT REMOVE
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]).then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'trippulse',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          // 🚨 CRITICAL: NEVER REMOVE OR MODIFY
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(1.0)),
              child: child!,
            );
          },
          // 🚨 END CRITICAL SECTION
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.initial,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case AppRoutes.initial:
                return MaterialPageRoute(builder: (_) => TripListScreen());
              case AppRoutes.tripList:
                return MaterialPageRoute(builder: (_) => TripListScreen());
              case AppRoutes.tripDetail:
                return MaterialPageRoute(builder: (_) => TripDetailScreen());
              case AppRoutes.dayItinerary:
                return MaterialPageRoute(builder: (_) => DayItineraryScreen());
              case AppRoutes.createTrip:
                return MaterialPageRoute(builder: (_) => CreateTripScreen());
              case AppRoutes.placesSearch:
                return MaterialPageRoute(builder: (_) => PlacesSearchScreen());
              case AppRoutes.placeDetail:
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (_) => PlaceDetailScreen(
                    placeId: args['placeId'],
                    placeName: args['placeName'],
                    placeData: args['placeData'],
                  ),
                );
              case AppRoutes.mapRoute:
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (_) =>
                      MapRouteScreen(placeDetails: args['placeDetails']),
                );
              case AppRoutes.generalMap:
                return MaterialPageRoute(
                  builder: (_) => const GeneralMapScreen(),
                );
              default:
                return MaterialPageRoute(builder: (_) => TripListScreen());
            }
          },
        );
      },
    );
  }
}
