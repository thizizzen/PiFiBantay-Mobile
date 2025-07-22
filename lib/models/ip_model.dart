class ManagedIP {
  final String ip;
  final String note;
  final DateTime addedAt;
  final bool isBlocked;
  final String type; // New field

  ManagedIP({
    required this.ip,
    required this.note,
    required this.addedAt,
    required this.isBlocked,
    required this.type,
  });

  factory ManagedIP.fromJson(Map<String, dynamic> json) {
    return ManagedIP(
      ip: json['ip'],
      note: json['note'],
      addedAt: DateTime.parse(json['addedAt']),
      isBlocked: json['isBlocked'],
      type: json['type'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() => {
        'ip': ip,
        'note': note,
        'addedAt': addedAt.toIso8601String(),
        'isBlocked': isBlocked,
        'type': type,
      };
}
