import 'package:dio/dio.dart';

class OpenRouteService {
  final Dio _dio = Dio();
  final String _apiKey =
      'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6IjBjYThjY2ZhYTVjYTQ2MWRhNDBhYmFmZDlhNzY1NGEzIiwiaCI6Im11cm11cjY0In0=';

  Future<Map<String, dynamic>?> getDirections(
    double startLat,
    double startLon,
    double endLat,
    double endLon,
  ) async {
    try {
      final response = await _dio.post(
        'https://api.openrouteservice.org/v2/directions/driving-car',
        data: {
          'coordinates': [
            [startLon, startLat],
            [endLon, endLat],
          ],
        },
        options: Options(
          headers: {
            'Authorization': _apiKey,
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error getting directions: $e');
      return null;
    }
  }
}
