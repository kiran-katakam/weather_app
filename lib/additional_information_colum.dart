import 'package:flutter/material.dart';

class AdditionalInformationColumn extends StatelessWidget {
  final IconData icon;
  final String data;
  final String value;
  const AdditionalInformationColumn({
    super.key,
    required this.icon,
    required this.data,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          data,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
