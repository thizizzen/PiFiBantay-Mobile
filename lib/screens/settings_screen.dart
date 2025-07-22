import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String userEmail = "admin@pifibantay.local";
  String securityQuestion = "What’s your favorite color?";

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

  void changeEmailDialog() {
    final controller = TextEditingController(text: userEmail);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1C2C3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Change Email", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: "New Email",
            labelStyle: TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => userEmail = controller.text);
              Navigator.pop(context);
              showSnack("Email updated!");
            },
            child: const Text("Save", style: TextStyle(color: Colors.amber)),
          )
        ],
      ),
    );
  }

  void changePasswordDialog() {
    final current = TextEditingController();
    final newPass = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1C2C3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Change Password", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: current,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Current Password",
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPass,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "New Password",
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showSnack("Password changed successfully.");
            },
            child: const Text("Update", style: TextStyle(color: Colors.amber)),
          )
        ],
      ),
    );
  }

  void changeSecurityQuestion() {
    final controller = TextEditingController(text: securityQuestion);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1C2C3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Security Question", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: "Your security question",
            labelStyle: TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => securityQuestion = controller.text);
              Navigator.pop(context);
              showSnack("Security question updated.");
            },
            child: const Text("Save", style: TextStyle(color: Colors.amber)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2C3A),
        title: const Text("Settings"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.email, color: Colors.white),
            title: const Text("Change Email", style: TextStyle(color: Colors.white)),
            subtitle: Text(userEmail, style: const TextStyle(color: Colors.white70)),
            onTap: changeEmailDialog,
          ),
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.white),
            title: const Text("Change Password", style: TextStyle(color: Colors.white)),
            onTap: changePasswordDialog,
          ),
          ListTile(
            leading: const Icon(Icons.question_answer, color: Colors.white),
            title: const Text("Security Question", style: TextStyle(color: Colors.white)),
            subtitle: Text(securityQuestion, style: const TextStyle(color: Colors.white70)),
            onTap: changeSecurityQuestion,
          ),
        ],
      ),
    );
  }
}