import 'dart:ui';
import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/alerts_screen.dart';
import 'screens/ip_management_screen.dart';
import 'screens/logs_screen.dart';
import 'screens/login_screen.dart';
import 'widgets/profile_drawer.dart';
import 'widgets/navigation_service.dart';

void main() {
  runApp(const PiFiBantayApp());
}

class PiFiBantayApp extends StatefulWidget {
  const PiFiBantayApp({super.key});

  @override
  State<PiFiBantayApp> createState() => _PiFiBantayAppState();
}

class _PiFiBantayAppState extends State<PiFiBantayApp> {
  int _selectedIndex = 0;
  bool isLoggedIn = false;
  bool isConnected = false;
  bool notificationsEnabled = true;
  String username = "Admin";

  @override
  void initState() {
    super.initState();
    NavigationService.setGoToAlerts(() {
      setState(() => _selectedIndex = 1);
    });
  }

  void _onItemTapped(int index) {
    if (index >= 0 && index < _screens.length) {
      setState(() => _selectedIndex = index);
    }
  }

  void toggleConnection(bool value) {
    setState(() => isConnected = value);
  }

  void toggleNotifications() {
    setState(() => notificationsEnabled = !notificationsEnabled);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
      if (scaffoldMessenger != null) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              notificationsEnabled
                  ? 'Notifications Enabled'
                  : 'Notifications Disabled',
            ),
          ),
        );
      }
    });
  }

  void login(String user) {
    setState(() {
      username = "Zhenrel Ocampo";
      isLoggedIn = true;
    });

    NavigationService.setGoToAlerts(() {
      setState(() => _selectedIndex = 1);
    });
  }

  void logout() {
    setState(() {
      isLoggedIn = false;
      isConnected = false;
    });
  }

  List<Widget> get _screens => [
    DashboardScreen(
      isConnected: isConnected,
      onConnectionToggle: toggleConnection,
      notificationsEnabled: notificationsEnabled,
    ),
    AlertsScreen(
      isConnected: isConnected,
      notificationsEnabled: notificationsEnabled,
    ),
    IpManagementScreen(),
    LogsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PiFiBantay',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0F2027),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1C2C3A),
          elevation: 4,
          shadowColor: Colors.black54,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
        ).copyWith(secondary: Colors.amber),
      ),
      home: isLoggedIn
          ? Scaffold(
              appBar: AppBar(
                toolbarHeight: 65,
                titleSpacing: 12,
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, size: 26),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                title: Image.asset('assets/images/logo.png', height: 43),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(
                      notificationsEnabled
                          ? Icons.notifications_active
                          : Icons.notifications_off,
                      color: notificationsEnabled
                          ? Colors.amber
                          : Colors.white60,
                    ),
                    onPressed: toggleNotifications,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              drawer: ProfileDrawer(
                username: username,
                onNavigate: _onItemTapped,
                onLogout: logout,
              ),
              body: Stack(
                children: [
                  IndexedStack(index: _selectedIndex, children: _screens),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                        left: 16,
                        right: 16,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: BottomNavigationBar(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              currentIndex: _selectedIndex,
                              onTap: _onItemTapped,
                              selectedItemColor: Colors.amber,
                              unselectedItemColor: Colors.white54,
                              type: BottomNavigationBarType.fixed,
                              selectedFontSize: 12,
                              unselectedFontSize: 11,
                              showUnselectedLabels: true,
                              items: const [
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.dashboard),
                                  label: 'Dashboard',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.warning),
                                  label: 'Alerts',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.shield),
                                  label: 'Management',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.list),
                                  label: 'Logs',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : LoginScreen(onLogin: login),
    );
  }
}