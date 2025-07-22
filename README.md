# PiFiBantay Mobile

**PiFiBantay Mobile** is a real-time mobile IDS/IPS (Intrusion Detection and Prevention System) monitoring and management application developed using Flutter. It provides administrators with the ability to monitor alerts, block suspicious IPs, view security logs, and configure system settings, all from their mobile device.

---

## 📱 Features

| Module           | Description                                                                 |
|------------------|-----------------------------------------------------------------------------|
| **Dashboard**    | Real-time overview of network status, system health, and quick summaries.   |
| **Alerts**       | Displays detected threats and suspicious activity in real-time.             |
| **Management**   | View, add, and manage blocked and whitelisted an IP addresses.                             |
| **Logs**         | Review detailed IDS/IPS logs and access historical data.                    |
| **Settings**     | Email change, password update, and security question.                       |
| **Drawer Navigation** | Access all modules and user info through an intuitive side drawer.     |

---

## 🛠 Project Structure

```
lib/
├── main.dart               # App entry point and state management
├── models/                 # Data models (alert_model.dart, ip_model.dart, log_model.dart)
├── screens/                # UI screens (dashboard, alerts, logs, settings, login)
├── widgets/                # Reusable UI components (cards, forms, drawers)
assets/
├── images/                 # App logo and profile image
├── data/                   # Static JSON files (alerts.json, logs.json, blocked_ips.json)
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- A connected device or emulator
- (Optional) Raspberry Pi device for production IDS/IPS backend

### Setup Steps

```bash
git clone https://github.com/thizizzen/PiFiBantay-Mobile.git
cd PiFiBantay-Mobile
flutter pub get
flutter run
```

---

## 👥 Contributors

- **Zhenrel L. Ocampo** – Lead Developer & Programmer  
- **Peter Amador P. Bon** – Documentation Support  
- **Marc Daniel D. Glaban** – Documentation Support  

---

## 📄 License

This project is for educational use and protected under standard open-source licenses unless otherwise stated.

---
