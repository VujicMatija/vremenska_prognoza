import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import 'package:vremenska_prognoza_v2/screens/weather.dart';

class LocationPage extends StatefulWidget {
  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  bool isGettingData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 102),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 200, 0, 50),
                  child: Text(
                    'Weather Forecast!',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 45),
                  ),
                ),
                const Spacer()
              ],
            ),
            isGettingData == false
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 17,
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20)))),
                          onPressed: () async {
                            setState(() {
                              isGettingData = true;
                            });
                            Location location = Location();

                            bool serviceEnabled;
                            PermissionStatus permissionGranted;
                            LocationData locationData;

                            serviceEnabled = await location.serviceEnabled();
                            if (!serviceEnabled) {
                              serviceEnabled = await location.requestService();
                              if (!serviceEnabled) {
                                return;
                              }
                            }

                            permissionGranted = await location.hasPermission();
                            if (permissionGranted == PermissionStatus.denied) {
                              permissionGranted =
                                  await location.requestPermission();
                              if (permissionGranted !=
                                  PermissionStatus.granted) {
                                return;
                              }
                            }

                            locationData = await location.getLocation();

                            var url = Uri.parse(
                                'https://maps.googleapis.com/maps/api/geocode/json?latlng=${locationData.latitude},${locationData.longitude}&result_type=locality&key=AIzaSyBMNh7Ba9HQ1s8-9cJr6mpAO_auR9NInKQ');

                            var response = await http.get(url);
                            Map data = json.decode(response.body);
                            print(data['results'][0]['address_components'][0]
                                ['long_name']);
                            if (context.mounted) {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => WeatherScreen(
                                    city: data['results'][0]
                                        ['address_components'][0]['long_name']),
                              ));
                            }
                          },
                          child: const Row(
                            children: [
                              Spacer(),
                              Icon(Icons.location_on),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'We need your current location',
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                              Spacer()
                            ],
                          )),
                    ),
                  )
                : const Text(
                    'Fetching data',
                    style: TextStyle(color: Colors.white, fontSize: 35),
                  ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: SizedBox(
            //     height: MediaQuery.of(context).size.height / 17,
            //     width: MediaQuery.of(context).size.width / 1.4,
            //     child: ElevatedButton(
            //         style: ButtonStyle(
            //             shape:
            //                 MaterialStateProperty.all<RoundedRectangleBorder>(
            //                     RoundedRectangleBorder(
            //                         borderRadius: BorderRadius.circular(20)))),
            //         onPressed: () async {
            //           Location location = Location();

            //           bool serviceEnabled;
            //           PermissionStatus permissionGranted;
            //           LocationData locationData;

            //           serviceEnabled = await location.serviceEnabled();
            //           if (!serviceEnabled) {
            //             serviceEnabled = await location.requestService();
            //             if (!serviceEnabled) {
            //               return;
            //             }
            //           }

            //           permissionGranted = await location.hasPermission();
            //           if (permissionGranted == PermissionStatus.denied) {
            //             permissionGranted = await location.requestPermission();
            //             if (permissionGranted != PermissionStatus.granted) {
            //               return;
            //             }
            //           }

            //           locationData = await location.getLocation();
            //           Navigator.of(context).push(MaterialPageRoute(
            //             builder: (context) => MapScreen(
            //                 lat: locationData.latitude,
            //                 long: locationData.longitude),
            //           ));
            //         },
            //         child: const Row(
            //           children: [
            //             Spacer(),
            //             Icon(Icons.map),
            //             Padding(
            //               padding: EdgeInsets.all(8.0),
            //               child: Text(
            //                 'Izaberite lokaciju sa mape',
            //                 style: TextStyle(fontSize: 20),
            //               ),
            //             ),
            //             Spacer()
            //           ],
            //         )),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
