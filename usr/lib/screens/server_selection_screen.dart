import 'package:flutter/material.dart';
import '../models/vpn_server.dart';

class ServerSelectionScreen extends StatelessWidget {
  final Function(VpnServer) onServerSelected;
  final VpnServer currentServer;

  const ServerSelectionScreen({
    super.key,
    required this.onServerSelected,
    required this.currentServer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Server"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: VpnServer.defaultServers.length,
        itemBuilder: (context, index) {
          final server = VpnServer.defaultServers[index];
          final isSelected = server.name == currentServer.name;

          return ListTile(
            leading: Text(
              server.flag,
              style: const TextStyle(fontSize: 30),
            ),
            title: Text(server.name),
            subtitle: Text(server.ip),
            trailing: isSelected
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.signal_cellular_alt, color: Colors.grey),
            onTap: () {
              onServerSelected(server);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
