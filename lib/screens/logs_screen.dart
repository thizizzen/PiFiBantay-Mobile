import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import '../models/log_model.dart';
import '../widgets/log_manager.dart';
import '../widgets/log_entry_tile.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  List<LogEntry> filteredLogs = [];
  String selectedFilter = "All";
  String selectedTimeRange = "All";
  bool _isDownloading = false;

  final dateFormat = DateFormat("yyyy-MM-dd hh:mm:ss a");

  final List<String> filterOptions = [
    "All",
    "Blocked",
    "Whitelisted",
    "Edited",
    "Deleted",
    "Detected",
  ];

  final List<String> timeFilters = [
    "All",
    "Last 24 Hours",
    "Last 7 Days",
    "Last 30 Days",
    "This Year",
  ];

  final List<Map<String, dynamic>> allAlerts = [
    {
      "timestamp": DateTime.now().toUtc().add(const Duration(hours: 8)),
      "ip": "192.168.1.105",
      "type": "Brute Force",
      "status": "Blocked",
    },
    {
      "timestamp": DateTime.now()
          .toUtc()
          .add(const Duration(hours: 8))
          .subtract(const Duration(days: 7)),
      "ip": "45.33.102.89",
      "type": "Port Scan",
      "status": "Blocked",
    },
    {
      "timestamp": DateTime.now()
          .toUtc()
          .add(const Duration(hours: 8))
          .subtract(const Duration(days: 30)),
      "ip": "103.45.78.201",
      "type": "Deauthentication",
      "status": "Investigating",
    },
    {
      "timestamp": DateTime.now()
          .toUtc()
          .add(const Duration(hours: 8))
          .subtract(const Duration(hours: 5)),
      "ip": "172.16.254.1",
      "type": "Port Scan",
      "status": "Resolved",
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshLogs();
  }

  void _refreshLogs() {
    final logManagerLogs = LogManager().logs;

    final fixedAlertLogs = allAlerts.map((alert) {
      final status = alert["status"];
      String message;

      if (status == "Blocked") {
        message = "The system blocked IP ${alert["ip"]} for ${alert["type"]}.";
      } else if (status == "Investigating") {
        message =
            "The system detected IP ${alert["ip"]} (${alert["type"]}) under investigation.";
      } else if (status == "Resolved") {
        message =
            "The system resolved a ${alert["type"]} alert from IP ${alert["ip"]}.";
      } else {
        message =
            "Alert: ${alert["type"]} from ${alert["ip"]}. Status: $status";
      }

      return LogEntry(timestamp: alert["timestamp"], message: message);
    }).toList();

    final allCombined = [...logManagerLogs, ...fixedAlertLogs];

    setState(() {
      filteredLogs = _applyAllFilters(allCombined);
    });
  }

  List<LogEntry> _applyAllFilters(List<LogEntry> logs) {
    final now = DateTime.now();
    DateTime? startTime;

    switch (selectedTimeRange) {
      case "Last 24 Hours":
        startTime = now.subtract(const Duration(hours: 24));
        break;
      case "Last 7 Days":
        startTime = now.subtract(const Duration(days: 7));
        break;
      case "Last 30 Days":
        startTime = now.subtract(const Duration(days: 30));
        break;
      case "This Year":
        startTime = DateTime(now.year);
        break;
    }

    return logs.where((log) {
      final matchesFilter =
          selectedFilter == "All" ||
          (selectedFilter == "Detected" &&
              log.message.contains("under investigation")) ||
          log.message.toLowerCase().contains(selectedFilter.toLowerCase());
      final matchesTime = startTime == null || log.timestamp.isAfter(startTime);
      return matchesFilter && matchesTime;
    }).toList();
  }

  void filterLogList(String filter) {
    _refreshLogs();
    setState(() {
      selectedFilter = filter;
    });
  }

  void changeTimeFilter(String timeFilter) {
    _refreshLogs();
    setState(() {
      selectedTimeRange = timeFilter;
    });
  }

  Future<void> downloadPDFLogs() async {
    setState(() => _isDownloading = true);
    await Future.delayed(const Duration(seconds: 1));

    final pdf = pw.Document();
    final logoBytes = await rootBundle.load('assets/images/logo.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        theme: pw.ThemeData.withFont(base: pw.Font.helvetica()),
        build: (context) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(logoImage, width: 50),
              pw.Text(
                "PiFiBantay Activity Logs",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                DateFormat("yyyy-MM-dd").format(DateTime.now()),
                style: const pw.TextStyle(fontSize: 10),
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Divider(thickness: 1),
          pw.SizedBox(height: 8),
          ...filteredLogs.map((log) {
            return pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 6),
              child: pw.Text(
                "[${dateFormat.format(log.timestamp)}] ${log.message}",
                style: const pw.TextStyle(fontSize: 11),
              ),
            );
          }),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/pifibantay_logs.pdf");
    await file.writeAsBytes(await pdf.save());

    if (context.mounted) {
      showSnack(" Logs downloaded to ${file.path}");
    }

    setState(() => _isDownloading = false);
  }

  void showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1C2C3A),
        content: Text(message, style: const TextStyle(color: Colors.white)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: LogManager(),
      builder: (context, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _refreshLogs();
        });

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedFilter,
                        dropdownColor: const Color(0xFF1C2C3A),
                        decoration: _dropdownStyle("Filter Logs"),
                        iconEnabledColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        items: filterOptions
                            .map(
                              (option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) filterLogList(val);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedTimeRange,
                        dropdownColor: const Color(0xFF1C2C3A),
                        decoration: _dropdownStyle("Time Range"),
                        iconEnabledColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        items: timeFilters
                            .map(
                              (time) => DropdownMenuItem(
                                value: time,
                                child: Text(time),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) changeTimeFilter(val);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    _isDownloading
                        ? const SizedBox(
                            width: 40,
                            height: 40,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.amber,
                              ),
                            ),
                          )
                        : IconButton(
                            onPressed: downloadPDFLogs,
                            icon: const Icon(
                              Icons.download,
                              color: Colors.amber,
                            ),
                            tooltip: "Download PDF",
                          ),
                  ],
                ),
              ),
              Expanded(
                child: filteredLogs.isEmpty
                    ? const Center(
                        child: Text(
                          "No logs found.",
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: filteredLogs.length,
                        itemBuilder: (context, index) {
                          return LogEntryTile(log: filteredLogs[index]);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _dropdownStyle(String label) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white10,
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white24),
      ),
    );
  }
}