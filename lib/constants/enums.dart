import 'package:flutter/material.dart';

enum TaskPriority {
  low(Colors.green, Icons.nightlight_round, 'Low'),
  medium(Colors.orange, Icons.access_time_filled, 'Medium'),
  high(Colors.red, Icons.priority_high, 'High');

  const TaskPriority(this.iconColor, this.icon, this.data);

  final Color iconColor;
  final IconData icon;
  final String data;
}
