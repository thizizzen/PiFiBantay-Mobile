import 'package:flutter/material.dart';
import '../models/alert_model.dart';

class AlertCard extends StatelessWidget {
  final Alert alert;

  const AlertCard({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        leading: Icon(Icons.warning, color: Colors.redAccent),
        title: Text(alert.type),
        subtitle: Text('${alert.ip} • ${alert.time}'),
      ),
    );
  }
}