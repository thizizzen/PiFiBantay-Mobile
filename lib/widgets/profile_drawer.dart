import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/settings_screen.dart';

class ProfileDrawer extends StatefulWidget {
  final String username;
  final Function(int) onNavigate;
  final VoidCallback onLogout;

  const ProfileDrawer({
    super.key,
    required this.username,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  String displayName = "";
  String workplace = "NBM Accounting & Auditing Services";
  File? profileImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = prefs.getString('displayName') ?? widget.username;
      workplace = prefs.getString('workplace') ?? "NBM Accounting & Auditing Services";
    });
  }

  Future<void> _saveProfileData(String name, String work) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('displayName', name);
    await prefs.setString('workplace', work);
  }

  void pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && mounted) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  void editProfileDialog(BuildContext context) {
    final nameController = TextEditingController(text: displayName);
    final workplaceController = TextEditingController(text: workplace);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1C2C3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white,
                  backgroundImage: profileImage != null
                      ? FileImage(profileImage!)
                      : const AssetImage('assets/images/profile.jpg') as ImageProvider,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Name"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: workplaceController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Workplace"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final newName = nameController.text;
              final newWorkplace = workplaceController.text;
              Navigator.pop(context);
              if (mounted) {
                setState(() {
                  displayName = newName;
                  workplace = newWorkplace;
                });
                _saveProfileData(newName, newWorkplace);
              }
            },
            child: const Text("Save", style: TextStyle(color: Colors.amber)),
          )
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white12,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rootContext = Navigator.of(context, rootNavigator: true).context;

    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0f2027), Color(0xFF203a43), Color(0xFF2c5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white,
                      backgroundImage: profileImage != null
                          ? FileImage(profileImage!)
                          : const AssetImage('assets/images/profile.jpg') as ImageProvider,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              displayName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            workplace,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              buildTile(
                icon: Icons.edit,
                label: "Edit Profile",
                onTap: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 250), () {
                    if (mounted) editProfileDialog(rootContext);
                  });
                },
              ),
              buildTile(
                icon: Icons.settings,
                label: "Settings",
                onTap: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 250), () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const SettingsScreen(),
                        transitionsBuilder: (_, animation, __, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;
                          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          return SlideTransition(position: animation.drive(tween), child: child);
                        },
                      ),
                    );
                  });
                },
              ),
              buildTile(
                icon: Icons.help_outline,
                label: "Help & Support",
                onTap: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 250), () {
                    showHelpDialog(rootContext);
                  });
                },
              ),
              buildTile(
                icon: Icons.info_outline,
                label: "App Info",
                onTap: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 250), () {
                    showAppInfoDialog(rootContext);
                  });
                },
              ),
              const Spacer(),
              const Divider(color: Colors.white30),
              buildTile(
                icon: Icons.logout,
                label: "Logout",
                onTap: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 250), () {
                    showDialog(
                      context: rootContext,
                      builder: (_) => AlertDialog(
                        backgroundColor: const Color(0xFF1C2C3A),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        title: const Text("Logout Confirmation", style: TextStyle(color: Colors.white)),
                        content: const Text(
                          "Are you sure you want to logout?",
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(rootContext).pop();
                            },
                            child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(rootContext).pop();
                              showDialog(
                                context: rootContext,
                                barrierDismissible: false,
                                barrierColor: const Color(0xFF0F2027),
                                builder: (_) => const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.amber,
                                    strokeWidth: 3,
                                  ),
                                ),
                              );
                              Future.delayed(const Duration(seconds: 1), () {
                                Navigator.of(rootContext).pop();
                                widget.onLogout();
                              });
                            },
                            child: const Text("Logout", style: TextStyle(color: Colors.amber)),
                          ),
                        ],
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
      hoverColor: Colors.white10,
    );
  }

  void showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1C2C3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Help & Support", style: TextStyle(color: Colors.white)),
        content: const Text(
          "For assistance, contact:\nadmin@pifibantay.local",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close", style: TextStyle(color: Colors.amber)),
          )
        ],
      ),
    );
  }

  void showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1C2C3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: const [
            Icon(Icons.security, color: Colors.amber),
            SizedBox(width: 8),
            Text("PiFiBantay", style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text(
          "Version: 1.0.0\n\nBuilt with Flutter for a real time IDS/IPS monitoring and management system.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close", style: TextStyle(color: Colors.amber)),
          )
        ],
      ),
    );
  }
}