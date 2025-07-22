# PiFiBantay Mobile

**PiFiBantay Mobile** is a real-time mobile IDS/IPS (Intrusion Detection and Prevention System) monitoring and management application developed using Flutter. It provides administrators with the ability to monitor alerts, block suspicious IPs, view security logs, and configure system settings — all from their mobile device.

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

##  Contributors
- **Zhenrel L. Ocampo** – Lead Developer & Programmer
- **Peter Amador P. Bon** – Documentation Support
- **Marc Daniel D. Glaban** – Documentation Support

---

##  License
This project is for educational use and protected under standard open-source licenses unless otherwise stated.

---

##  Notes
- The current mobile application is a simulation of how the system works when integrated with the Raspberry Pi device.
- Make sure to connect the app to a real-time IDS/IPS backend to get live alerts and logs.
- Developed by IT students of Batangas State University for academic purposes.

---

##  Key Features

###  Security & Detection
- **Real-time WiFi Scanning** - Comprehensive network discovery and analysis
- **Evil Twin Detection** - Advanced algorithms using signal pattern analysis and MAC verification
- **Threat Scoring System** - Dynamic risk assessment (0–100 scale) for detected networks
- **Security Alerts** - Instant notifications for potential threats
- **Government Whitelist Integration** - Verification against approved network databases

###  User Experience
- **Interactive Dashboard** - Visual network maps and security status
- **Educational Content** - Cybersecurity learning modules and quizzes
- **Offline Mode** - Full functionality without internet connection
- **Material Design 3** - Modern, accessible user interface
- **Multi-language Support** - English and Filipino/Tagalog (planned)

###  Technical Features
- **Clean Architecture** - Scalable and maintainable codebase
- **Firebase Integration** - Cloud services for data sync and analytics
- **Cross-platform Support** - Android (primary) with iOS roadmap
- **Performance Optimized** - 60fps UI with efficient memory usage

##  Requirements
- Flutter SDK >=3.0.0
- Android 6.0+ (API Level 23+)
- Dart >=3.0.0

---

## USER ACCEPTANCE TESTING (UAT)

This part outlines the User Acceptance Testing (UAT) conducted to verify that the
**PiFiBantay Mobile** meets the functional requirements and expectations of its intended
users. UAT ensures the application is ready for real-world usage by validating each key
feature based on test scenarios.

### UAT Environment

| Item              | Description                  |
|-------------------|------------------------------|
| Device            | Android Phone / Emulator     |
| OS Version        | Android 12+                  |
| App Version       | 1.0.0                        |
| Development Tool  | Flutter                      |
| Framework         | Flutter SDK 3.x              |
| Testing Tool      | Manual User Testing          |

### Test Cases

| Test Case ID | Test Scenario               | Test Description                                                                 | Expected Result                                     | Actual Result       | Status            |
|--------------|-----------------------------|----------------------------------------------------------------------------------|------------------------------------------------------|----------------------|--------------------|
| UAT-01       | View About Section          | Verify the expand/collapse behavior of the About section using "Show more/less" | Text expands and collapses properly                 | Works as expected   | Passed             |
| UAT-02       | Navigate via Drawer Menu    | Validate drawer navigation between About, Research, and Experience sections     | Correct screen is displayed for each option         | Works as expected   | Passed             |
| UAT-03       | Search Research Projects    | Ensure keyword search filters the research items                                | Matching research items are displayed               | Works as expected   | Passed             |
| UAT-04       | Expand Experience Items     | Check if tapping an experience entry expands to show more information           | Description details become visible                  | Works as expected   | Passed             |
| UAT-05       | Responsive Layout and Theming | Observe layout adaptability on screen resize or rotation                        | Layout adapts correctly without overflow            | Works as expected | Passed |

---
