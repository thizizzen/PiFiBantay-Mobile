import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/log_model.dart';

class LogEntryTile extends StatelessWidget {
  final LogEntry log;

  const LogEntryTile({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("yyyy-MM-dd hh:mm:ss a");

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.event_note, color: Colors.amber),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.message,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat.format(log.timestamp),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}