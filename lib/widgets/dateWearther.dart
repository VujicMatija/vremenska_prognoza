import 'package:flutter/material.dart';

class DateWeather extends StatelessWidget {
  DateWeather({
    super.key,
    required this.date,
    required this.temp_max,
    required this.temp_avg,
    required this.temp_min,
    required this.weather_cond,
    required this.rain,
    required this.wind_speed,
  });
  final String date;
  final String temp_min;
  final String temp_max;
  final String temp_avg;
  final String wind_speed;
  final String weather_cond;
  String rain;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          date,
          style: const TextStyle(fontSize: 24),
        ),
        Text(
          'Average temperature ${temp_avg}ºC',
          style: const TextStyle(fontSize: 24),
        ),
        Text(
          'Weather condition: $weather_cond',
          style: const TextStyle(fontSize: 24),
        ),
        Text(
          'Chance of rain: $rain%',
          style: const TextStyle(fontSize: 24),
        ),
        Text(
          'Wind Speed: $wind_speed km/h',
          style: const TextStyle(fontSize: 24),
        ),
        const Divider(
          color: Colors.black,
        )
      ],
    );
  }
}
