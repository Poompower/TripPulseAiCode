import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/geoapify_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../routes/app_routes.dart';

class PlaceDetailScreen extends StatefulWidget {
  final String placeId;
  final String placeName;
  final Map<String, dynamic>? placeData;

  const PlaceDetailScreen({
    super.key,
    required this.placeId,
    required this.placeName,
    this.placeData,
  });

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  final GeoApifyService _geoApifyService = GeoApifyService();
  Map<String, dynamic>? _placeDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaceDetails();
  }

  Future<void> _loadPlaceDetails() async {
    if (widget.placeData != null) {
      // Use provided mock data
      setState(() {
        _placeDetails = widget.placeData;
        _isLoading = false;
      });
    } else {
      // Fetch from API
      setState(() => _isLoading = true);
      final details = await _geoApifyService.getPlaceDetails(widget.placeId);
      setState(() {
        _placeDetails = details;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.placeName,
        automaticallyImplyLeading: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _placeDetails == null
          ? const Center(child: Text('Failed to load place details'))
          : SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Place Image
                  if (_placeDetails!['image'] != null)
                    Container(
                      height: 30.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.w),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            _placeDetails!['image'],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else if (_placeDetails!['properties']?['image'] != null)
                    Container(
                      height: 30.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.w),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            _placeDetails!['properties']['image'],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  SizedBox(height: 3.h),

                  // Place Name
                  Text(
                    _placeDetails!['name'] ??
                        _placeDetails!['properties']?['name'] ??
                        widget.placeName,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Categories
                  if (_placeDetails!['category'] != null)
                    Wrap(
                      spacing: 2.w,
                      children: [
                        Chip(
                          label: Text(_placeDetails!['category']),
                          backgroundColor: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.1),
                        ),
                      ],
                    )
                  else if (_placeDetails!['properties']?['categories'] != null)
                    Wrap(
                      spacing: 2.w,
                      children:
                          (_placeDetails!['properties']['categories'] as List)
                              .map(
                                (category) => Chip(
                                  label: Text(category.toString()),
                                  backgroundColor: Theme.of(
                                    context,
                                  ).primaryColor.withOpacity(0.1),
                                ),
                              )
                              .toList(),
                    ),

                  SizedBox(height: 2.h),

                  // Address
                  if (_placeDetails!['distance'] != null)
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 5.w),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            _placeDetails!['distance'],
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ],
                    )
                  else if (_placeDetails!['properties']?['formatted'] != null)
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 5.w),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            _placeDetails!['properties']['formatted'],
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),

                  SizedBox(height: 2.h),

                  // Description
                  if (_placeDetails!['description'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          _placeDetails!['description'],
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ],
                    )
                  else if (_placeDetails!['properties']?['description'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          _placeDetails!['properties']['description'],
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ],
                    ),

                  SizedBox(height: 3.h),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to map/route view
                            Navigator.pushNamed(
                              context,
                              AppRoutes.mapRoute,
                              arguments: {'placeDetails': _placeDetails},
                            );
                          },
                          icon: Icon(Icons.map, size: 5.w),
                          label: Text('View on Map'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
