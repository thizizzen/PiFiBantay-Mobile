# PiFiBantay Mobile

**PiFiBantay Mobile** is a real-time mobile IDS/IPS (Intrusion Detection and Prevention System) monitoring and management application developed using Flutter. It provides administrators with the ability to monitor alerts, block suspicious IPs, view security logs, and configure system settings, all from their mobile device.

---

## Features

| Module          | Description                                                                 |
|-----------------|-----------------------------------------------------------------------------|
| **Dashboard**   | Real-time overview of network status, system health, and quick summaries.  |
| **Alerts**      | Displays detected threats and suspicious activity in real-time.            |
| **Blocked IPs** | View, add, and manage blocked and whitelisted IP addresses.                            |
| **Logs**        | Review detailed IDS/IPS logs and access historical data.                   |
| **Settings**    | Update email, change password, and security question.                      |
| **Drawer Navigation** | Access all modules and user info through an intuitive side drawer.   |

---
##  Key Features

### Security & Detection
- **Real-time Threat Monitoring** - Detects and displays incoming alerts as they occur.
- **Blocked IP Management** - Allows administrators to review and unblock flagged IP addresses.
- **Log Viewer** - Keeps a detailed record of events, intrusions, and admin actions.
- **Alert Center** - Displays categorized threat notifications and summaries.
- **Notification Toggle** - Enables/disables real-time security alerts.

### Admin & Control
- **Dashboard Overview** - A centralized page to view statistics and security status.
- **Profile Drawer** - Quick admin info and navigation accessible via drawer.
- **Connection Control** - Manually toggle system connectivity state.

### Technical Features
- **Flutter Framework** - Built entirely using Flutter and Dart for cross-platform support.
- **Clean Architecture** - Separated screens, widgets, and models for maintainability.
- **Custom Widgets** - Reusable components such as `alert_card`, `log_entry_tile`, and `chip_status`.
- **Offline-ready Design** - Data stored locally in JSON format for offline simulation.
- **Responsive UI** - Works across screen sizes with Material Design principles.

---

##  Project Structure

```bash
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

## Requirements

- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- Android 6.0+ (API Level 23+)
- Visual Studio Code or Android Studio

##  Getting Started

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

##  Notes
- The current mobile application is a simulation of how the system works when integrated with the Raspberry Pi device.
- Make sure to connect the app to a real-time IDS/IPS backend to get live alerts and logs.
- Developed by IT students of Batangas State University for academic purposes.

---

##  Contributors
- **Zhenrel L. Ocampo** – Lead Developer, Programmer & UI/UX Designer
- **Peter Amador P. Bon** – System Tester & Documentation Support
- **Marc Daniel D. Glaban** – System Tester & Documentation Support

---

##  License
This project is for educational use and protected under standard open-source licenses unless otherwise stated.

---
