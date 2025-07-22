class Alert {
  final String type;
  final String ip;
  final DateTime time;

  Alert({required this.type, required this.ip, required this.time});

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      type: json['type'],
      ip: json['ip'],
      time: DateTime.parse(json['time']),
    );
  }
}