import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/ip_model.dart';

class BlockedIpTile extends StatelessWidget {
  final ManagedIP ip;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const BlockedIpTile({
    super.key,
    required this.ip,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd hh:mm a');
    final isBlocked = ip.isBlocked;

    return Card(
      child: ListTile(
        leading: Icon(
          isBlocked ? Icons.block : Icons.check_circle,
          color: isBlocked ? Colors.red : Colors.green,
        ),
        title: Text(ip.ip),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Note: ${ip.note.isNotEmpty ? ip.note : 'None'}"),
            Text("Added: ${dateFormat.format(ip.addedAt)}"),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            } else if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }
}