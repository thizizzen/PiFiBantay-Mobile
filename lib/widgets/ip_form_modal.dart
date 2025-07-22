import 'package:flutter/material.dart';
import '../models/ip_model.dart';
import 'ip_manager.dart';

void showIpFormModal({
  required BuildContext context,
  ManagedIP? existingIp,
  required Function(ManagedIP) onSubmit,
}) {
  final ipController = TextEditingController(text: existingIp?.ip ?? '');
  final noteController = TextEditingController(text: existingIp?.note ?? '');
  bool isBlocked = existingIp?.isBlocked ?? true;
  String attackType = existingIp?.type ?? "Other";

  final List<String> attackTypes = [
    "Other",
    "Brute Force",
    "Port Scan",
    "Deauthentication"
  ];

  String? errorText;

  showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          backgroundColor: const Color(0xFF1C2C3A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 360,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  existingIp == null ? 'Add IP Address' : 'Edit IP',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: ipController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("IP Address").copyWith(
                    errorText: errorText,
                  ),
                ),
                const SizedBox(height: 14),
                _buildTextArea(noteController, "Note"),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: attackType,
                  dropdownColor: const Color(0xFF1C2C3A),
                  decoration: _inputDecoration("Threat Type"),
                  items: attackTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type, style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => attackType = val);
                  },
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text("Blocked"),
                        labelStyle: TextStyle(
                          color: isBlocked ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        selected: isBlocked,
                        selectedColor: Colors.redAccent,
                        backgroundColor: const Color(0xFF263645),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        showCheckmark: false,
                        onSelected: (_) => setState(() => isBlocked = true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text("Whitelisted"),
                        labelStyle: TextStyle(
                          color: !isBlocked ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        selected: !isBlocked,
                        selectedColor: Colors.greenAccent,
                        backgroundColor: const Color(0xFF263645),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        showCheckmark: false,
                        onSelected: (_) => setState(() => isBlocked = false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel", style: TextStyle(color: Colors.white60)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade600,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        final ip = ipController.text.trim();
                        final note = noteController.text.trim();

                        final ipRegex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
                        final alreadyExists = IPManager().isBlocked(ip) || IPManager().isWhitelisted(ip);
                        final isNewOrDifferent = existingIp == null || ip != existingIp.ip;

                        if (ip.isEmpty) {
                          setState(() => errorText = "IP Address is required.");
                          return;
                        } else if (!ipRegex.hasMatch(ip)) {
                          setState(() => errorText = "Invalid IP address format.");
                          return;
                        } else if (alreadyExists && isNewOrDifferent) {
                          setState(() => errorText = "IP already exists.");
                          return;
                        }

                        final newIp = ManagedIP(
                          ip: ip,
                          note: note,
                          addedAt: DateTime.now(),
                          isBlocked: isBlocked,
                          type: attackType,
                        );
                        onSubmit(newIp);

                        Navigator.pop(context);
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

InputDecoration _inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.white70),
    filled: true,
    fillColor: Colors.white10,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.black54),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.amber),
    ),
  );
}

Widget _buildTextArea(TextEditingController controller, String label) {
  return TextField(
    controller: controller,
    style: const TextStyle(color: Colors.white),
    maxLines: 3,
    decoration: _inputDecoration(label),
  );
}