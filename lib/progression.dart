import 'package:flutter/material.dart';

class ProgressionBar extends StatelessWidget {
  final double current;
  final double total;

  const ProgressionBar({super.key, required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Text('Question ${current.toInt()} sur ${total.toInt()}', style: const TextStyle(fontSize: 25)),
        LinearProgressIndicator(
          value: current / total,
          minHeight: 20,
          borderRadius: BorderRadius.circular(10),
          backgroundColor: Colors.grey[300],
          color: Colors.deepPurple,
        ),
      ],
    );
  }
}
