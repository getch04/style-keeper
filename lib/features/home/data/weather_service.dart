import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherInfo {
  final String description;
  final double temperature;
  final String icon;

  WeatherInfo({
    required this.description,
    required this.temperature,
    required this.icon,
  });
}

class WeatherService {
  Future<WeatherInfo?> fetchWeather() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("Location services are disabled.");
        return null;
      }

      // Check permission status
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("Location permission denied.");
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print("Location permission permanently denied.");
        return null;
      }

      // Get current location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      final lat = position.latitude;
      final lon = position.longitude;

      // Get NWS point metadata
      const pointUrl = 'https://api.weather.gov/points/39.7456,-97.0892';
      final pointResponse = await http.get(Uri.parse(pointUrl));

      if (pointResponse.statusCode != 200) {
        print("Failed to get point metadata.");
        return null;
      }

      final pointData = json.decode(pointResponse.body);
      final forecastUrl = pointData['properties']['forecast'];

      // Get forecast data
      final forecastResponse = await http.get(Uri.parse(forecastUrl));
      if (forecastResponse.statusCode != 200) {
        print("Failed to get forecast data.");
        return null;
      }

      final forecastData = json.decode(forecastResponse.body);
      final currentPeriod = forecastData['properties']['periods'][0];

      return WeatherInfo(
        description: currentPeriod['shortForecast'],
        temperature: currentPeriod['temperature'].toDouble(),
        icon: currentPeriod['icon'],
      );
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
