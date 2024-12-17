import 'package:flutter/material.dart';
import 'package:weather_app/global_variables.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 24),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 18),
                child: Text(
                  "City",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: textEditingController,
                  onSubmitted: (value) {
                    setState(() {
                      cityName = value;
                    });
                  },
                  decoration: InputDecoration(
                      enabled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30))),
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            cityName = textEditingController.text;
          },
          child: Text("Save"),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(40, 40),
            disabledMouseCursor: MouseCursor.uncontrolled
          ),
        ),
      ],
    );
  }
}
