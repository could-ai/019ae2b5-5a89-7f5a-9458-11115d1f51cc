import 'package:flutter/material.dart';
import '../services/mock_vpn_service.dart';
import '../widgets/mock_ad_dialog.dart';
import 'server_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // In a real app, use Provider/Riverpod/Bloc for state management.
  // Using a singleton-like instance here for simplicity in this demo.
  final MockVpnService _vpnService = MockVpnService();

  @override
  void initState() {
    super.initState();
    _vpnService.addListener(_updateState);
  }

  @override
  void dispose() {
    _vpnService.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    setState(() {});
  }

  void _handleConnectPress() {
    if (_vpnService.status == VpnStatus.disconnected) {
      // Show Ad before connecting
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => MockAdDialog(
          onAdComplete: () {
            _vpnService.connect();
          },
        ),
      );
    } else {
      _vpnService.disconnect();
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _vpnService.status;
    final isConnected = status == VpnStatus.connected;
    final isConnecting = status == VpnStatus.connecting;
    
    // Singapore Red for primary color
    Color primaryColor = isConnected ? Colors.green : const Color(0xFFEF3340);
    String statusText = isConnected 
        ? "CONNECTED" 
        : isConnecting 
            ? "CONNECTING..." 
            : "DISCONNECTED";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Singapore VPN"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.workspace_premium, color: Colors.amber),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          // Status Area
          const SizedBox(height: 40),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _vpnService.durationText,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontFamily: 'Monospace',
            ),
          ),

          // Main Button Area
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: isConnecting ? null : _handleConnectPress,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isConnected 
                              ? [Colors.green.shade400, Colors.green.shade700]
                              : [const Color(0xFFEF3340), const Color(0xFFD02030)], // Singapore Red Gradient
                        ),
                      ),
                      child: Icon(
                        Icons.power_settings_new,
                        size: 80,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Server Selection
          Padding(
            padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
            child: InkWell(
              onTap: isConnected || isConnecting 
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Disconnect first to change server")),
                      );
                    } 
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServerSelectionScreen(
                            currentServer: _vpnService.selectedServer,
                            onServerSelected: (server) {
                              _vpnService.setServer(server);
                            },
                          ),
                        ),
                      );
                    },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      _vpnService.selectedServer.flag,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Current Location",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            _vpnService.selectedServer.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
