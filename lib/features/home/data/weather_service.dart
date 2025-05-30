import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherInfo {
  final String description;
  final double temperature;
  final String icon;

  WeatherInfo(
      {required this.description,
      required this.temperature,
      required this.icon});
}

class WeatherService {
  static const String _apiKey = '458890748a67e946adcb7137f914cdd1';
  Future<WeatherInfo?> fetchWeather() async {
    try {
      //request permission
      await Geolocator.requestPermission();
      // Get current position

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);

      // Fetch weather data
      final url =
          'http://api.weatherstack.com/current?access_key=$_apiKey&query=${position.latitude},${position.longitude}';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherInfo(
          description: data['current']['weather_descriptions'][0],
          temperature: (data['current']['temperature'] as num).toDouble(),
          icon: data['current']['weather_icons'][0],
        );
      }
    } catch (e) {
      // Handle error or permission denied
      return null;
    }
    return null;
  }
}
