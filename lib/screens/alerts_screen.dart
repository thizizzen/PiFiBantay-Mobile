import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/chip_status.dart';
import '../widgets/navigation_service.dart';
import '../widgets/ip_manager.dart';
import '../widgets/log_manager.dart';

class WhitelistManager {
  static final WhitelistManager _instance = WhitelistManager._internal();
  factory WhitelistManager() => _instance;
  WhitelistManager._internal();

  final List<String> whitelistedIPs = [];

  void add(String ip) {
    if (!whitelistedIPs.contains(ip)) {
      whitelistedIPs.add(ip);
    }
  }

  List<String> get all => whitelistedIPs;
}

class AlertsScreen extends StatefulWidget {
  final bool isConnected;
  final bool notificationsEnabled;

  const AlertsScreen({
    super.key,
    required this.isConnected,
    required this.notificationsEnabled,
  });

  @override
  _AlertsScreenState createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
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

  List<Map<String, dynamic>> filteredAlerts = [];
  String selectedType = "All";
  String selectedTime = "All";
  TextEditingController searchController = TextEditingController();

  final List<String> threatTypes = [
    "All",
    "Brute Force",
    "Port Scan",
    "Deauthentication",
  ];
  final List<String> timeRanges = [
    "All",
    "Last 24 Hours",
    "Last 7 Days",
    "Last 30 Days",
  ];

  late Timer _liveUpdateTimer;

  @override
  void initState() {
    super.initState();
    filteredAlerts = List.from(allAlerts);
    searchController.addListener(applyFilters);

    for (var alert in allAlerts) {
      if (alert['status'] == 'Blocked') {
        IPManager().block(
          alert['ip'],
          type: alert['type'],
          note: 'None',
          addedAt: alert['timestamp'],
        );
      } else if (alert['status'] == 'Whitelisted') {
        IPManager().whitelist(
          alert['ip'],
          type: alert['type'],
          note: 'None',
          addedAt: alert['timestamp'],
        );
      }
    }

    _liveUpdateTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      _generateNewAlert();
    });
  }

  void _generateNewAlert() {
    if (!widget.isConnected) return;

    final types = ["Brute Force", "Port Scan", "Deauthentication"];
    final status = (allAlerts.length % 2 == 0) ? "Investigating" : "Blocked";
    final ip = "192.168.1.${100 + allAlerts.length}";
    final type = types[allAlerts.length % types.length];
    final timestamp = DateTime.now().toUtc().add(const Duration(hours: 8));

    final newAlert = {
      "timestamp": timestamp,
      "ip": ip,
      "type": type,
      "status": status,
    };

    if (status == "Blocked") {
      IPManager().block(ip, type: type, note: '', addedAt: timestamp);
    } else if (status == "Whitelisted") {
      IPManager().whitelist(ip, type: type, note: '', addedAt: timestamp);
    }

    setState(() {
      allAlerts.insert(0, newAlert);
      applyFilters();
    });

    if (status == "Blocked") {
      LogManager().addLog(
        "The system has automatically blocked a potential $type attack from $ip.",
      );
    } else if (status == "Investigating") {
      LogManager().addLog(
        "The system has detected a potential $type attack from $ip and is currently investigating.",
      );
    }

    if (widget.notificationsEnabled) {
      showTopNotification(
        context,
        "Alert: $type from $ip ($status). Tap to view details.",
      );
    }
  }

  void applyFilters() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 8));
    final keyword = searchController.text.toLowerCase();

    setState(() {
      filteredAlerts = allAlerts.where((alert) {
        final time = alert["timestamp"];
        final matchesSearch =
            alert["ip"].toLowerCase().contains(keyword) ||
            alert["type"].toLowerCase().contains(keyword) ||
            alert["status"].toLowerCase().contains(keyword);

        final matchesType =
            selectedType == "All" || alert["type"] == selectedType;

        final matchesTime = () {
          if (selectedTime == "All") return true;
          if (selectedTime == "Last 24 Hours") {
            return now.difference(time).inHours <= 24;
          }
          if (selectedTime == "Last 7 Days") {
            return now.difference(time).inDays <= 7;
          }
          if (selectedTime == "Last 30 Days") {
            return now.difference(time).inDays <= 30;
          }
          return true;
        }();

        return matchesSearch && matchesType && matchesTime;
      }).toList();
    });
  }

  void confirmAction({
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1C2C3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Text(content, style: const TextStyle(color: Colors.white70)),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white70,
              textStyle: const TextStyle(fontWeight: FontWeight.w500),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text("Confirm", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void showTopNotification(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _DraggableNotification(
        message: message,
        onDismissed: () => overlayEntry.remove(),
        onTap: () {
          overlayEntry.remove();
          NavigationService.triggerGoToAlerts();
        },
      ),
    );

    overlay.insert(overlayEntry);
  }

  @override
  void dispose() {
    searchController.dispose();
    _liveUpdateTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    height: 48,
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Search threats...",
                        labelStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        filled: true,
                        fillColor: Colors.white12,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white24),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 0,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 48,
                    child: _buildDropdown(threatTypes, selectedType, "Type", (
                      val,
                    ) {
                      setState(() => selectedType = val);
                      applyFilters();
                    }),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 48,
                    child: _buildDropdown(timeRanges, selectedTime, "Time", (
                      val,
                    ) {
                      setState(() => selectedTime = val);
                      applyFilters();
                    }),
                  ),
                ),

                const SizedBox(width: 12),

                SizedBox(
                  width: 48,
                  height: 48,
                  child: IconButton(
                    tooltip: "Refresh Alerts",
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.amber,
                      size: 26,
                    ),
                    onPressed: () {
                      if (widget.isConnected) {
                        _generateNewAlert();
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredAlerts.length,
              itemBuilder: (context, index) {
                final alert = filteredAlerts[index];
                return _buildAlertCard(alert);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final dateFormat = DateFormat('yyyy-MM-dd hh:mm a');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Time: ${dateFormat.format(alert["timestamp"])}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "IP Address: ${alert['ip']}",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Type: ${alert['type']}",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "Status: ",
                      style: TextStyle(color: Colors.white70),
                    ),
                    ChipStatus(alert['status']),
                  ],
                ),
                Row(
                  children: [
                    if (alert['status'] == 'Blocked')
                      IconButton(
                        tooltip: 'Unblock',
                        icon: const Icon(
                          Icons.lock_open,
                          color: Colors.greenAccent,
                        ),
                        onPressed: () {
                          confirmAction(
                            title: "Unblock Threat",
                            content:
                                "Do you want to Mark this threat as resolved?",
                            onConfirm: () {
                              setState(() {
                                alert['status'] = 'Resolved';
                              });
                              LogManager().addLog(
                                "${alert['ip']} has been manually removed from the blocklist by the admin. (${alert['type']})",
                              );
                            },
                          );
                        },
                      ),
                    if (alert['status'] == 'Investigating') ...[
                      IconButton(
                        tooltip: 'Block',
                        icon: const Icon(Icons.block, color: Colors.redAccent),
                        onPressed: () {
                          confirmAction(
                            title: "Block IP",
                            content:
                                "Do you want to Block this IP from accessing the network?",
                            onConfirm: () {
                              setState(() {
                                alert['status'] = 'Blocked';
                                IPManager().block(
                                  alert['ip'],
                                  type: alert['type'] ?? 'Unknown',
                                  note: '',
                                  addedAt: alert['timestamp'],
                                );
                              });
                              LogManager().addLog(
                                "The admin has manually ${alert['ip']} due to ${alert['type']} threat.",
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        tooltip: 'Whitelist',
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          confirmAction(
                            title: "Whitelist IP",
                            content:
                                "Do you want to Whitelist this IP permanently?",
                            onConfirm: () {
                              setState(() {
                                alert['status'] = 'Whitelisted';
                                IPManager().whitelist(
                                  alert['ip'],
                                  type: alert['type'] ?? 'Unknown',
                                  note: '',
                                  addedAt: alert['timestamp'],
                                );
                              });
                              LogManager().addLog(
                                "The admin has added ${alert['ip']} to the whitelist. Reason (${alert['type']})",
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    List<String> options,
    String value,
    String label,
    Function(String) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: value,
      dropdownColor: const Color(0xFF1C2C3A),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),

      iconEnabledColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      items: options.map((val) {
        return DropdownMenuItem(value: val, child: Text(val));
      }).toList(),
      onChanged: (val) {
        if (val != null) onChanged(val);
      },
    );
  }
}

class _DraggableNotification extends StatefulWidget {
  final String message;
  final VoidCallback onDismissed;
  final VoidCallback? onTap;

  const _DraggableNotification({
    required this.message,
    required this.onDismissed,
    this.onTap,
  });

  @override
  State<_DraggableNotification> createState() => _DraggableNotificationState();
}

class _DraggableNotificationState extends State<_DraggableNotification>
    with SingleTickerProviderStateMixin {
  double offsetY = 0;
  bool dismissed = false;
  late AnimationController _controller;
  late Animation<double> _fadeOut;
  Timer? _autoDismissTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeOut = Tween<double>(begin: 1, end: 0).animate(_controller);

    _autoDismissTimer = Timer(const Duration(seconds: 4), () {
      _dismiss();
    });
  }

  void _dismiss() {
    if (dismissed) return;
    dismissed = true;
    _controller.forward().whenComplete(widget.onDismissed);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      offsetY += details.delta.dy;
    });

    _autoDismissTimer?.cancel();
  }

  void _handleDragEnd(DragEndDetails details) {
    if (offsetY < -50) {
      _dismiss();
    } else {
      setState(() {
        offsetY = 0;
      });

      if (!dismissed) {
        _autoDismissTimer = Timer(const Duration(seconds: 5), _dismiss);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40 + offsetY,
      left: 40,
      right: 40,
      child: FadeTransition(
        opacity: _fadeOut,
        child: GestureDetector(
          onTap: widget.onTap,
          onVerticalDragUpdate: _handleDragUpdate,
          onVerticalDragEnd: _handleDragEnd,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xFF1C2C3A).withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                widget.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}