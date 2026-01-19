import 'dart:io';

import 'weather_api_client.dart';

void main(List<String> argument) async {
  if (argument.length != 1) {
    print("Syntax:dart bin/main.dart");
    return;
  }
  try {
    final city = argument.first;
    final api = WeatherApiClient();
    final weather = await api.getWeather(city);
    print('City: $city');
    print(
      'Temperature: ${weather['current_condition'][0]['temp_C']}°C',
    );
  } on SocketException catch (_) {
    print("Could not fetch data.Check your connections.");
  } catch (e) {
    print(e);
  }
}
