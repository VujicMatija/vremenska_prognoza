import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vremenska_prognoza_v2/widgets/clock.dart';
import 'package:http/http.dart' as http;
import 'package:vremenska_prognoza_v2/widgets/dateWearther.dart';

class WeatherScreen extends StatefulWidget {
  WeatherScreen({super.key, required this.city});
  String city;
  @override
  State<StatefulWidget> createState() {
    return _WeatherScreenState();
  }
}

class _WeatherScreenState extends State<WeatherScreen> {
  String? temp;
  List<String> dates = [];
  List<Map<String, String>> daysData = [];
  String wind_dir = '';

  void getData() async {
    var url = Uri.parse(
        'http://api.weatherapi.com/v1/forecast.json?key=e3339df6deb44fe6848132636230909&q=${widget.city}&days=3&aqi=no&alerts=no');
    var response = await http.get(url);
    var data = json.decode(response.body);

    setState(() {
      double t1 = data['current']['temp_c'];
      int t2 = t1.round();
      temp = t2.toString();
      wind_dir = data['current']['wind_dir'];
      for (Map day in data['forecast']['forecastday']) {
        dates.add(day['date']);
        daysData.add({
          'date': day['date'],
          'max_temp': day['day']['maxtemp_c'].toString(),
          'min_temp': day['day']['mintemp_c'].toString(),
          'average_temp': day['day']['avgtemp_c'].toString(),
          'rain_chance': day['day']['daily_chance_of_rain'].toString(),
          'wind_speed': day['day']['maxwind_kph'].toString(),
          'condition': day['day']['condition']['text'],
        });
      }
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Today'),
          BottomNavigationBarItem(
              icon: Icon(Icons.date_range), label: 'Three days')
        ],
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Theme.of(context).colorScheme.primary,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 3 / 5,
                            height: MediaQuery.of(context).size.height / 10,
                            child: Text(
                              widget.city,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 40),
                            ),
                          ),
                        ),
                        const Clock(),
                      ],
                    ),
                    const VerticalDivider(
                      color: Colors.white,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const Spacer(),
                          const Text('Current temperature',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15)),
                          temp != null
                              ? Text(
                                  '$tempºC',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 48),
                                )
                              : const CircularProgressIndicator(),
                          const Spacer()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
              child: Card(
                color: Colors.blueGrey.shade300,
                elevation: 20,
                child: daysData.length != 0
                    ? _currentIndex == 0
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Average temperature: ${daysData[0]['average_temp']}ºC',
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Max temperature: ${daysData[0]['max_temp']}ºC',
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Min temperature: ${daysData[0]['min_temp']}ºC',
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                              const Divider(
                                color: Colors.black,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Weather condition: ${daysData[0]['condition']}',
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Chance of rain is: ${daysData[0]['rain_chance']}%',
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                              const Divider(
                                color: Colors.black,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Wind Speed: ${daysData[0]['wind_speed']} km/h',
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Wind Direction: $wind_dir',
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                              const Divider(
                                color: Colors.black,
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              DateWeather(
                                  date: daysData[0]['date']!,
                                  temp_max: daysData[0]['max_temp']!,
                                  temp_avg: daysData[0]['average_temp']!,
                                  temp_min: daysData[0]['max_temp']!,
                                  weather_cond: daysData[0]['condition']!,
                                  rain: daysData[0]['rain_chance']!,
                                  wind_speed: daysData[0]['wind_speed']!),
                              DateWeather(
                                  date: daysData[1]['date']!,
                                  temp_max: daysData[1]['max_temp']!,
                                  temp_avg: daysData[1]['average_temp']!,
                                  temp_min: daysData[1]['max_temp']!,
                                  weather_cond: daysData[1]['condition']!,
                                  rain: daysData[1]['rain_chance']!,
                                  wind_speed: daysData[1]['wind_speed']!),
                              DateWeather(
                                  date: daysData[2]['date']!,
                                  temp_max: daysData[2]['max_temp']!,
                                  temp_avg: daysData[2]['average_temp']!,
                                  temp_min: daysData[2]['max_temp']!,
                                  weather_cond: daysData[2]['condition']!,
                                  rain: daysData[2]['rain_chance']!,
                                  wind_speed: daysData[2]['wind_speed']!)
                            ],
                          )
                    : const CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
