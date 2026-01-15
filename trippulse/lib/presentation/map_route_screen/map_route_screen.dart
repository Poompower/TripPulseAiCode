import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sizer/sizer.dart';
import '../../services/openroute_service.dart';
import '../../widgets/custom_app_bar.dart';

class MapRouteScreen extends StatefulWidget {
  final Map<String, dynamic> placeDetails;

  const MapRouteScreen({super.key, required this.placeDetails});

  @override
  State<MapRouteScreen> createState() => _MapRouteScreenState();
}

class _MapRouteScreenState extends State<MapRouteScreen> {
  final OpenRouteService _openRouteService = OpenRouteService();
  final MapController _mapController = MapController();

  LatLng? _currentLocation;
  LatLng? _destinationLocation;
  List<LatLng> _routePoints = [];
  bool _isLoadingRoute = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _parsePlaceLocation();
  }

  void _parsePlaceLocation() {
    final geometry = widget.placeDetails['geometry'];
    if (geometry != null && geometry['coordinates'] != null) {
      final coords = geometry['coordinates'] as List;
      if (coords.length >= 2) {
        _destinationLocation = LatLng(coords[1], coords[0]);
      }
    } else if (widget.placeDetails['coordinates'] != null) {
      // Handle mock data format
      final coords = widget.placeDetails['coordinates'];
      _destinationLocation = LatLng(coords['lat'], coords['lng']);
    }
  }

  Future<void> _initializeLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition();
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _getRoute() async {
    if (_currentLocation == null || _destinationLocation == null) return;

    setState(() => _isLoadingRoute = true);

    final routeData = await _openRouteService.getDirections(
      _currentLocation!.latitude,
      _currentLocation!.longitude,
      _destinationLocation!.latitude,
      _destinationLocation!.longitude,
    );

    if (routeData != null && routeData['routes'] != null) {
      final route = routeData['routes'][0];
      final geometry = route['geometry'];

      if (geometry != null) {
        // Decode the polyline (simplified - in real app you'd use a proper decoder)
        final coordinates = geometry['coordinates'] as List;
        final points = coordinates
            .map((coord) => LatLng(coord[1], coord[0]))
            .toList();

        setState(() {
          _routePoints = points;
          _isLoadingRoute = false;
        });
      }
    } else {
      setState(() => _isLoadingRoute = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final placeName = widget.placeDetails['properties']?['name'] ?? 'Place';

    return Scaffold(
      appBar: CustomAppBar(
        title: '$placeName - Map',
        automaticallyImplyLeading: true,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _destinationLocation ?? LatLng(0, 0),
              zoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.trippulse',
              ),
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      color: Colors.blue,
                      strokeWidth: 4.0,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  if (_destinationLocation != null)
                    Marker(
                      point: _destinationLocation!,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  if (_currentLocation != null)
                    Marker(
                      point: _currentLocation!,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                ],
              ),
            ],
          ),

          // Route Button
          Positioned(
            bottom: 4.h,
            left: 4.w,
            right: 4.w,
            child: ElevatedButton.icon(
              onPressed: _isLoadingRoute ? null : _getRoute,
              icon: _isLoadingRoute
                  ? SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Icon(Icons.directions, size: 5.w),
              label: Text(
                _isLoadingRoute ? 'Getting Route...' : 'Get Directions',
                style: TextStyle(fontSize: 14.sp),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ),

          // Current Location Button
          Positioned(
            top: 4.h,
            right: 4.w,
            child: FloatingActionButton(
              onPressed: () {
                if (_currentLocation != null) {
                  _mapController.move(_currentLocation!, 15.0);
                }
              },
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
