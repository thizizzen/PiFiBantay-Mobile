import 'package:flutter/foundation.dart';
import '../models/log_model.dart';

class LogManager extends ChangeNotifier {
  static final LogManager _instance = LogManager._internal();

  factory LogManager() => _instance;

  LogManager._internal();

  final List<LogEntry> _logs = [];

  List<LogEntry> get logs => List.unmodifiable(_logs);

  void addLog(String message) {
    if (message.trim().isEmpty) return;
    _logs.insert(
      0,
      LogEntry(timestamp: DateTime.now(), message: message.trim()),
    );
    notifyListeners();
  }

  void clearLogs() {
    _logs.clear();
    notifyListeners();
  }

  void addIPLog({required String ip, required String action, String? type}) {
    String log = '';

    switch (action.toLowerCase()) {
      case 'block':
        log = "🛑 IP address $ip was blocked for ${type ?? 'suspicious activity'}.";
        break;
      case 'whitelist':
        log = "✅ IP address $ip was whitelisted (${type ?? 'manually approved'}).";
        break;
      case 'unblock':
        log = "🔓 IP address $ip has been unblocked and marked as resolved.";
        break;
      case 'detect':
        log = "⚠️ ${type ?? 'Unknown'} attack detected from $ip.";
        break;
      default:
        log = "$action action on IP: $ip";
    }

    addLog(log);
  }
}