import 'package:flutter/material.dart';

class ChipStatus extends StatelessWidget {
  final String status;

  const ChipStatus(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'blocked':
        color = Colors.redAccent;
        break;
      case 'resolved':
        color = Colors.green;
        break;
      case 'investigating':
        color = Colors.orange;
        break;
      case 'monitored':
        color = Colors.blue;
        break;
      case 'whitelisted':
        color = Colors.teal;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}