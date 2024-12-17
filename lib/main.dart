import 'package:flutter/material.dart';
import 'package:weather_app/scaffold.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Weather App",
      home: const MainScaffold(),
      theme: ThemeData.dark(useMaterial3: true),
    );
  }
}
