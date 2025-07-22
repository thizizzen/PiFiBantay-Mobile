import 'package:flutter/material.dart';
import '../models/ip_model.dart';

class IPManager {
  static final IPManager _instance = IPManager._internal();

  factory IPManager() => _instance;

  IPManager._internal();

  final Map<String, ManagedIP> _blocked = {};
  final Map<String, ManagedIP> _whitelisted = {};

  final ValueNotifier<int> notifier = ValueNotifier(0);

  void block(String ip, {String note = '', String type = 'Unknown', DateTime? addedAt}) {
    _whitelisted.remove(ip);
    _blocked[ip] = ManagedIP(
      ip: ip,
      note: note,
      type: type,
      isBlocked: true,
      addedAt: addedAt ?? DateTime.now(),
    );
    notifier.value++;
  }

  void whitelist(String ip, {String note = '', String type = 'Unknown', DateTime? addedAt}) {
    _blocked.remove(ip);
    _whitelisted[ip] = ManagedIP(
      ip: ip,
      note: note,
      type: type,
      isBlocked: false,
      addedAt: addedAt ?? DateTime.now(),
    );
    notifier.value++;
  }

  List<ManagedIP> getBlockedIPs() => _blocked.values.toList();
  List<ManagedIP> getWhitelistedIPs() => _whitelisted.values.toList();

  bool isBlocked(String ip) => _blocked.containsKey(ip);
  bool isWhitelisted(String ip) => _whitelisted.containsKey(ip);

  void removeIp(String ip) {
    _blocked.remove(ip);
    _whitelisted.remove(ip);
    notifier.value++;
  }
}