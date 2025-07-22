import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/summary_card.dart';

class DashboardScreen extends StatefulWidget {
  final bool isConnected;
  final bool notificationsEnabled;
  final Function(bool) onConnectionToggle;

  const DashboardScreen({
    super.key,
    required this.isConnected,
    required this.notificationsEnabled,
    required this.onConnectionToggle,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  late AnimationController _controller;
  Timer? _dataTimer;

  int totalThreats = 5;
  int blockedIPs = 2;
  int activeConnections = 4;

  final Random _random = Random();

  List<FlSpot> bruteForce = [];
  List<FlSpot> portScan = [];
  List<FlSpot> deauth = [];
  double _xValue = 3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isConnected && !oldWidget.isConnected) {
      _startDataUpdates();
    } else if (!widget.isConnected && oldWidget.isConnected) {
      _stopDataUpdates();
    }
  }

  void _startDataUpdates() {
    _dataTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() {
        totalThreats = 3 + _random.nextInt(8);
        blockedIPs = 1 + _random.nextInt(5);
        activeConnections = 4 + _random.nextInt(3);

        _xValue += 1;
        bruteForce.add(FlSpot(_xValue, _random.nextDouble() * 2 + 1));
        portScan.add(FlSpot(_xValue, _random.nextDouble() * 2));
        deauth.add(FlSpot(_xValue, _random.nextDouble() + 0.5));

        if (bruteForce.length > 10) bruteForce.removeAt(0);
        if (portScan.length > 10) portScan.removeAt(0);
        if (deauth.length > 10) deauth.removeAt(0);
      });
    });
  }

  void _stopDataUpdates() {
    _dataTimer?.cancel();
  }

  void toggleConnection() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    widget.onConnectionToggle(!widget.isConnected);
    setState(() => isLoading = false);

    showSnack(
      widget.isConnected
          ? "Disconnected from Raspberry Pi"
          : "Connected to Raspberry Pi!",
    );
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
  void dispose() {
    _controller.dispose();
    _stopDataUpdates();
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
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color.fromARGB(60, 255, 255, 255), width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: ListTile(
                leading: Icon(
                  widget.isConnected ? Icons.router : Icons.wifi_off,
                  color: widget.isConnected ? Colors.green : Colors.redAccent,
                  size: 32,
                ),
                title: const Text(
                  "Raspberry Pi Connection",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                subtitle: Text(
                  widget.isConnected
                      ? "Connected to 192.168.1.254"
                      : "Not Connected",
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: ElevatedButton(
                  onPressed: isLoading ? null : toggleConnection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        widget.isConnected ? Colors.redAccent : Colors.green,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          widget.isConnected ? "Disconnect" : "Connect",
                          style: const TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (widget.isConnected)
              Column(
                children: [
                  const Text(
                    "Monitoring Status",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Real-time network scan in progress...",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (_, child) {
                        return Transform.rotate(
                          angle: _controller.value * 6.28,
                          child: child,
                        );
                      },
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.greenAccent.withOpacity(0.3),
                              Colors.greenAccent.withOpacity(0.0),
                            ],
                            radius: 0.8,
                          ),
                          border: Border.all(color: Colors.greenAccent, width: 2),
                        ),
                        child: const Center(
                          child: Icon(Icons.wifi_tethering,
                              color: Colors.greenAccent, size: 40),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            if (!widget.isConnected)
              Column(
                children: const [
                  Icon(Icons.warning_amber_rounded,
                      size: 48, color: Colors.white70),
                  SizedBox(height: 8),
                  Text(
                    "Connect to Raspberry Pi to view dashboard data.",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            if (widget.isConnected) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      label: "Total Threats",
                      value: "$totalThreats",
                      subtitle: "↑ ${_random.nextInt(5) + 1}% from last scan",
                      icon: Icons.shield,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SummaryCard(
                      label: "Blocked IPs",
                      value: "$blockedIPs",
                      subtitle: "↑ ${_random.nextInt(3) + 1} IPs today",
                      icon: Icons.block,
                      color: Colors.purpleAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      label: "Active Connections",
                      value: "$activeConnections",
                      subtitle: "LAN Devices Detected",
                      icon: Icons.network_check,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: SummaryCard(
                      label: "System Status",
                      value: "Protected",
                      subtitle: "Live monitoring active",
                      icon: Icons.verified,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Threats Over Time",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: bruteForce,
                              color: Colors.redAccent,
                              isCurved: true,
                              barWidth: 2,
                              dotData: FlDotData(show: false),
                            ),
                            LineChartBarData(
                              spots: portScan,
                              color: Colors.blueAccent,
                              isCurved: true,
                              barWidth: 2,
                              dotData: FlDotData(show: false),
                            ),
                            LineChartBarData(
                              spots: deauth,
                              color: Colors.purpleAccent,
                              isCurved: true,
                              barWidth: 2,
                              dotData: FlDotData(show: false),
                            ),
                          ],
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: Colors.black87,
                              getTooltipItems: (spots) {
                                return spots.map((spot) {
                                  String type = spot.bar.color == Colors.redAccent
                                      ? "Brute Force"
                                      : spot.bar.color == Colors.blueAccent
                                          ? "Port Scan"
                                          : "Deauthentication";
                                  return LineTooltipItem(
                                    '$type\nTime: ${spot.x.toInt()}\nValue: ${spot.y.toStringAsFixed(1)}',
                                    const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}