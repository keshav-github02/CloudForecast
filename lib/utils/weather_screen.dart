import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/utils/additional_info.dart';
import 'package:weather_app/utils/hourly_forcast_cards.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String cityName = 'London';
  double currentTemp = 0;
  String currentSkyCondition = '';
  bool isLoading = true;

  double currentWindSpeed=0;
  double currentHumidity=0;
  double currentPressure=0;




  TextEditingController cityController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<void> getCurrentWeather() async {
    try {
      String apiKey = '768150900190749c248bbbf192f2ee81';

      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          currentTemp = (data['main']['temp'] - 273.15);
          isLoading = false;
          currentSkyCondition = data['weather'][0]['main'];
          currentWindSpeed=data['wind']['speed'];
          currentHumidity=data['main']['humidity'].toDouble();
          currentPressure=data['main']['pressure']/100;
        });
      } else {
        print('Error: ${response.statusCode}');
      }

      final hourlyResponse= await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey'
      ));
      if(hourlyResponse.statusCode==200){
        final hourlyData = jsonDecode(hourlyResponse.body);


      }

    else {
    print('Error: ${hourlyResponse.statusCode}');
    }


    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          cityName[0].toUpperCase() + cityName.substring(1),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                getCurrentWeather();
                print('RadheRadhe');
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.black,
              ))
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 10,
                        child: Column(
                          children: [
                            Text(
                              '${currentTemp.toStringAsFixed(2)} °C ',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              currentSkyCondition == 'Clouds' ||
                                      currentSkyCondition == 'Mist' ||
                                      currentSkyCondition == 'Rain'
                                  ? Icons.cloud
                                  : Icons.sunny,
                              size: 64,
                              color: currentSkyCondition == 'Clouds' ||
                                      currentSkyCondition == 'Mist' ||
                                      currentSkyCondition == 'Rain'
                                  ? Colors.blueGrey
                                  : Colors.yellow[700],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              currentSkyCondition,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hourly Forecast',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    const SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [

                          HourlyForcastcard(),
                          HourlyForcastcard(),
                          HourlyForcastcard(),
                          HourlyForcastcard(),
                          HourlyForcastcard(),
                          HourlyForcastcard(),
                          HourlyForcastcard(),
                          HourlyForcastcard(),
                          HourlyForcastcard(),
                          HourlyForcastcard(),
                          HourlyForcastcard(),
                          HourlyForcastcard(),
                          HourlyForcastcard(),
                          HourlyForcastcard(),
                          HourlyForcastcard(),
                          HourlyForcastcard(),
                          HourlyForcastcard(),
                          HourlyForcastcard(),
                          HourlyForcastcard(),
                          HourlyForcastcard(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Additional Info',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 12,
                    ),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AdditionalInfo(
                          title: 'Wind',
                          value: currentWindSpeed.toString() + 'Km/hr',
                          icon: Icons.air,
                        ),
                        AdditionalInfo(
                          title: 'Humidity',
                          value: currentHumidity.toString() +'%',
                          icon: Icons.water,
                        ),
                        AdditionalInfo(
                          title: 'Pressure',
                          value: currentPressure.toStringAsFixed(2) +'hPa',
                          icon: Icons.arrow_downward,
                        ),

                      ],
                    ),
                    const SizedBox(
                      height: 75,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Change Location'),
                                  content: TextField(
                                    controller: cityController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter City Name',

                                    ),
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z'))],
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel')),
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            cityName = cityController.text;
                                            isLoading = true;
                                          });
                                        },
                                        child: const Text('Ok')),
                                  ],
                                );
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        child: const Text(
                          'Change Location',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
