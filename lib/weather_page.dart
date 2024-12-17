import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:weather_app/additional_information_colum.dart';
import 'package:weather_app/global_variables.dart';
import 'package:weather_app/weather_forcast_card.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late Future<Map<String, dynamic>> weatherForecastFuture =
      getCurrentForecast();

  void refreshWeatherData() {
    setState(() {
      weatherForecastFuture = getCurrentForecast();
    });
  }

  double kelvinToCelsius(dynamic kelvin) {
    double temp;

    if (kelvin is int) {
      temp = kelvin.toDouble();
    } else if (kelvin is double) {
      temp = kelvin;
    } else {
      throw ArgumentError('Expected int or double, got ${kelvin.runtimeType}');
    }
    return double.parse((temp - 273.15).toStringAsFixed(2));
  }

  IconData weatherIcon(String data) {
    if (data == "Clouds") {
      return Icons.cloud;
    } else if (data == "Rain") {
      return Icons.cloudy_snowing;
    } else if (data == "Clear") {
      return Icons.sunny;
    } else {
      return Icons.cloud_off_outlined;
    }
  }

  Future<Map<String, dynamic>> getCurrentForecast() async {
    try {
      final forecast = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$apiKey'),
      );

      final data = jsonDecode(forecast.body);

      if (data['cod'] != "200") {
        throw data["message"];
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: weatherForecastFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (snapshot.hasError) {
          if (snapshot.error == "city not found") {
            isInvalidCity = true;
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.not_listed_location_outlined,
                    size: 80,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Text(
                          "Invalid City",
                          style: TextStyle(fontSize: 32),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          if ((snapshot.error).toString().contains("errno = 11001") ||
              (snapshot.error).toString().contains("errno = 7")) {
            snapshot.data.toString().indexOf("errno");
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_off_rounded,
                    size: 80,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "No Internet!",
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                ],
              ),
            );
          }
          return Text(snapshot.error.toString());
        }

        final data = snapshot.data!;

        final currentWeatherData = data["list"][0];

        final currentTemperature =
            kelvinToCelsius(currentWeatherData["main"]["temp"]);
        final currentSky = currentWeatherData["weather"][0]["main"];
        final humidity = currentWeatherData["main"]["humidity"];
        final windSpeed = currentWeatherData["wind"]["speed"];
        final pressure = currentWeatherData["main"]["pressure"];
        final list = data["list"];
        final Map cards = {
          "card1": [
            DateTime.parse(list[1]["dt_txt"]),
            list[1]["weather"][0]["main"],
            list[1]["main"]["temp"]
          ],
          "card2": [
            DateTime.parse(list[2]["dt_txt"]),
            list[2]["weather"][0]["main"],
            list[2]["main"]["temp"]
          ],
          "card3": [
            DateTime.parse(list[3]["dt_txt"]),
            list[3]["weather"][0]["main"],
            list[3]["main"]["temp"]
          ],
          "card4": [
            DateTime.parse(list[4]["dt_txt"]),
            list[4]["weather"][0]["main"],
            list[4]["main"]["temp"]
          ],
          "card5": [
            DateTime.parse(list[5]["dt_txt"]),
            list[5]["weather"][0]["main"],
            list[5]["main"]["temp"]
          ],
        };
        isInvalidCity = false;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // main card (to occupy maximum width)
              SizedBox(
                width: double.infinity,
                // main card
                child: Card(
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  // ClipRRect to prevent the cool effect destroy elevation give border radius
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    // backdrop filter for cool merge effect
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 4,
                        sigmaY: 4,
                      ),
                      // wrapped with padding for top/bottom padding in main card
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        // main card column
                        child: Column(
                          children: [
                            // temperature
                            Text(
                              "$currentTemperature°C",
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // icon
                            Icon(
                              weatherIcon(currentSky),
                              size: 64,
                            ),
                            const SizedBox(height: 10),
                            // status
                            Text(
                              currentSky,
                              style: const TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // wrapped with padding for top and bottom padding for the text
              const Padding(
                padding: EdgeInsets.only(
                  top: 12,
                  bottom: 4,
                ),
                // wrapped with align to align it left
                child: Align(
                  alignment: Alignment.centerLeft,
                  // weather forcast text
                  child: Text(
                    "Hourly Forcast",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // weather foracast with 3 hrs interval
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    WeatherForcastCard(
                      time: DateFormat.j().format(cards["card1"][0]),
                      icon: weatherIcon(cards["card1"][1]),
                      temperature: "${kelvinToCelsius(cards["card1"][2])}",
                    ),
                    WeatherForcastCard(
                      time: DateFormat.j().format(cards["card2"][0]),
                      icon: weatherIcon(cards["card2"][1]),
                      temperature: "${kelvinToCelsius(cards["card2"][2])}",
                    ),
                    WeatherForcastCard(
                      time: DateFormat.j().format(cards["card3"][0]),
                      icon: weatherIcon(cards["card3"][1]),
                      temperature: "${kelvinToCelsius(cards["card3"][2])}",
                    ),
                    WeatherForcastCard(
                      time: DateFormat.j().format(cards["card4"][0]),
                      icon: weatherIcon(cards["card4"][1]),
                      temperature: "${kelvinToCelsius(cards["card4"][2])}",
                    ),
                    WeatherForcastCard(
                      time: DateFormat.j().format(cards["card5"][0]),
                      icon: weatherIcon(cards["card5"][1]),
                      temperature: "${kelvinToCelsius(cards["card5"][2])}",
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 4,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Additional Information",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              // additional information
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInformationColumn(
                    icon: Icons.water_drop,
                    data: "Humidity",
                    value: "$humidity",
                  ),
                  AdditionalInformationColumn(
                    icon: Icons.air,
                    data: "Wind Speed",
                    value: "$windSpeed",
                  ),
                  AdditionalInformationColumn(
                    icon: Icons.beach_access,
                    data: "Pressure",
                    value: "$pressure",
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
