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
  static const String _apiKey =
      'YOUR_OPENWEATHERMAP_API_KEY'; // <-- Replace with your API key

  Future<WeatherInfo?> fetchWeather() async {
    try {
      // Get current position
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);

      // Fetch weather data
      final url =
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=$_apiKey';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherInfo(
          description: data['weather'][0]['main'],
          temperature: (data['main']['temp'] as num).toDouble(),
          icon: data['weather'][0]['icon'],
        );
      }
    } catch (e) {
      // Handle error or permission denied
      return null;
    }
    return null;
  }
}
