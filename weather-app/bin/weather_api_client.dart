import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApiClient {
  static const baseUrl = "https://wttr.in";

  Future<Map<String, dynamic>> getWeather(String city) async {
    final url = Uri.parse('$baseUrl/$city?format=j1');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch weather');
    }

    return jsonDecode(response.body);
  }
}
