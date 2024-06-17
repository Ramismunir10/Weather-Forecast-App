import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherService {
  final String apiKey = '10c04b92f0f661080d90a55f2344b6df';

  Future<Map<String, dynamic>> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse(
          'http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed To Load Data');
    }
  }

  Future<Map<String, dynamic>> fetchWeather() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    double lat = position.latitude, lon = position.longitude;
    final response = await http.get(
      Uri.parse(
          'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed To Load Data');
    }
  }
}
