import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/ip_model.dart';
import '../widgets/ip_form_modal.dart';
import '../widgets/ip_manager.dart';
import '../widgets/log_manager.dart';

class IpManagementScreen extends StatefulWidget {
  const IpManagementScreen({super.key});

  @override
  State<IpManagementScreen> createState() => _IpManagementScreenState();
}

class _IpManagementScreenState extends State<IpManagementScreen> {
  String search = "";
  final dateFormat = DateFormat("yyyy-MM-dd hh:mm a");

  void _addOrEditIp(ManagedIP newIp, [ManagedIP? oldIp, bool suppressLog = false]) {
    final log = LogManager();

    if (oldIp != null) {
      IPManager().removeIp(oldIp.ip);
    }

    if (newIp.isBlocked) {
      IPManager().block(
        newIp.ip,
        note: newIp.note,
        type: newIp.type,
        addedAt: newIp.addedAt,
      );
    } else {
      IPManager().whitelist(
        newIp.ip,
        note: newIp.note,
        type: newIp.type,
        addedAt: newIp.addedAt,
      );
    }

    if (!suppressLog) {
      final status = newIp.isBlocked ? "BLOCKED" : "WHITELISTED";
      final threat = newIp.type.isEmpty ? 'None' : newIp.type;
      final note = newIp.note.isEmpty ? 'None' : newIp.note;

      log.addLog(
        "The Admin edited IP ${newIp.ip}: status changed to $status, threat type: '$threat', note: '$note'."
      );
    }

    setState(() {});
  }

  void _deleteIp(ManagedIP ip) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1C2C3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Remove IP",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        content: Text(
          "Are you sure you want to permanently remove ${ip.ip} from the records?",
          style: const TextStyle(color: Colors.white70),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white70,
              textStyle: const TextStyle(fontWeight: FontWeight.w500),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              IPManager().removeIp(ip.ip);
              LogManager().addLog("The admin has removed IP ${ip.ip} from the system.");
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          ),
        ],
      ),
    );
  }

  List<ManagedIP> _filtered(List<ManagedIP> list) {
    return list
        .where((ip) =>
            ip.ip.contains(search) ||
            ip.note.toLowerCase().contains(search.toLowerCase()) ||
            ip.type.toLowerCase().contains(search.toLowerCase()))
        .toList()
      ..sort((a, b) => b.addedAt.compareTo(a.addedAt));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TabBar(
                    labelColor: Colors.amber,
                    unselectedLabelColor: Colors.white60,
                    indicatorColor: Colors.amber,
                    indicatorWeight: 2.5,
                    tabs: [
                      Tab(text: "Blocked"),
                      Tab(text: "Whitelisted"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white10,
                      labelText: "Search IP, note, or type...",
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                    ),
                    onChanged: (val) => setState(() => search = val),
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: IPManager().notifier,
                    builder: (context, _, __) {
                      return TabBarView(
                        children: [
                          _buildIpList(_filtered(IPManager().getBlockedIPs()), true),
                          _buildIpList(_filtered(IPManager().getWhitelistedIPs()), false),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: FloatingActionButton(
              backgroundColor: Colors.amber.shade600,
              foregroundColor: Colors.black,
              onPressed: () {
                showIpFormModal(
                  context: context,
                  onSubmit: (ip) => _addOrEditIp(ip),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIpList(List<ManagedIP> list, bool blocked) {
    if (list.isEmpty) {
      return Center(
        child: Text(
          "No ${blocked ? 'blocked' : 'whitelisted'} IPs",
          style: const TextStyle(color: Colors.white54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final ip = list[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            border: Border.all(color: Colors.white10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              blocked ? Icons.block : Icons.check_circle,
              color: blocked ? Colors.redAccent : Colors.greenAccent,
            ),
            title: Text(
              ip.ip,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text("Type: ${ip.type}", style: const TextStyle(color: Colors.white70)),
                Text("Note: ${ip.note.isEmpty ? 'None' : ip.note}",
                    style: const TextStyle(color: Colors.white70)),
                Text("Added: ${dateFormat.format(ip.addedAt)}",
                    style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
            trailing: PopupMenuButton<String>(
              color: const Color(0xFF1F2F3C),
              icon: const Icon(Icons.more_vert, color: Colors.white70),
              onSelected: (value) {
                if (value == 'edit') {
                  showIpFormModal(
                    context: context,
                    existingIp: ip,
                    onSubmit: (newIp) => _addOrEditIp(newIp, ip),
                  );
                } else if (value == 'delete') {
                  _deleteIp(ip);
                } else if (value == 'unblock') {
                  final newIp = ManagedIP(
                    ip: ip.ip,
                    note: ip.note,
                    addedAt: ip.addedAt,
                    isBlocked: false,
                    type: ip.type,
                  );
                  LogManager().addLog(
                    "The Admin unblocked IP ${ip.ip} and marked it as whitelisted."
                  );
                  _addOrEditIp(newIp, ip, true);
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Text("Edit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
                ),
                if (ip.isBlocked)
                  PopupMenuItem(
                    value: 'unblock',
                    child: Text("Unblock", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}