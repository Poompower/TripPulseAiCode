import 'package:dio/dio.dart';

class GeoApifyService {
  final Dio _dio = Dio();
  final String _apiKey = '41e231e5d78c40178f3b2a111eeb5d56';

  Future<List<Map<String, dynamic>>> searchPlaces(
    String query,
    double lat,
    double lon,
  ) async {
    try {
      final response = await _dio.get(
        'https://api.geoapify.com/v2/places',
        queryParameters: {
          'apiKey': _apiKey,
          'text': query,
          'bias': 'proximity:$lon,$lat',
          'limit': 20,
          'categories': 'tourism.sights,commercial,entertainment,catering',
        },
      );

      if (response.statusCode == 200) {
        final features = response.data['features'] as List;
        return features
            .map((feature) => feature as Map<String, dynamic>)
            .toList();
      }
      return [];
    } catch (e) {
      print('Error searching places: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
    try {
      final response = await _dio.get(
        'https://api.geoapify.com/v2/place-details',
        queryParameters: {
          'apiKey': _apiKey,
          'id': placeId,
          'features': 'details,geometry',
        },
      );

      if (response.statusCode == 200) {
        return response.data['features']?[0] as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error getting place details: $e');
      return null;
    }
  }
}
