import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sizer/sizer.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';

class GeneralMapScreen extends StatefulWidget {
  const GeneralMapScreen({super.key});

  @override
  State<GeneralMapScreen> createState() => _GeneralMapScreenState();
}

class _GeneralMapScreenState extends State<GeneralMapScreen> {
  final MapController _mapController = MapController();

  LatLng? _currentLocation;
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    setState(() => _isLoadingLocation = true);

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
          _isLoadingLocation = false;
        });

        // Move map to current location
        _mapController.move(_currentLocation!, 15.0);
      } else {
        setState(() => _isLoadingLocation = false);
        // Default to a general location if permission denied
        _currentLocation = LatLng(48.8566, 2.3522); // Paris
      }
    } catch (e) {
      print('Error getting location: $e');
      setState(() => _isLoadingLocation = false);
      // Default to Paris if location fails
      _currentLocation = LatLng(48.8566, 2.3522);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Map Explorer',
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 2,
        onTap: (index) {
          if (index != 2) {
            CustomBottomBar.navigateToIndex(context, index);
          }
        },
        variant: BottomBarVariant.material3,
        showLabels: true,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _currentLocation ?? LatLng(48.8566, 2.3522),
              zoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.trippulse',
              ),
              if (_currentLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation!,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          Icons.my_location,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Loading indicator
          if (_isLoadingLocation)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),

          // Current Location Button
          Positioned(
            bottom: 4.h,
            right: 4.w,
            child: FloatingActionButton(
              onPressed: () {
                if (_currentLocation != null) {
                  _mapController.move(_currentLocation!, 15.0);
                } else {
                  _initializeLocation();
                }
              },
              child: const Icon(Icons.my_location),
            ),
          ),

          // Info text
          Positioned(
            top: 4.h,
            left: 4.w,
            right: 4.w,
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Text(
                'Explore places on the map. Tap on places in Search to view detailed maps with directions.',
                style: TextStyle(fontSize: 12.sp),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
