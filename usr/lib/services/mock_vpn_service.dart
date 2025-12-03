import 'dart:async';
import 'package:flutter/material.dart';
import '../models/vpn_server.dart';

enum VpnStatus { disconnected, connecting, connected }

class MockVpnService extends ChangeNotifier {
  VpnStatus _status = VpnStatus.disconnected;
  VpnServer _selectedServer = VpnServer.defaultServers[0];
  DateTime? _startTime;
  Timer? _timer;
  String _durationText = "00:00:00";

  VpnStatus get status => _status;
  VpnServer get selectedServer => _selectedServer;
  String get durationText => _durationText;

  void setServer(VpnServer server) {
    if (_status == VpnStatus.disconnected) {
      _selectedServer = server;
      notifyListeners();
    }
  }

  Future<void> connect() async {
    if (_status != VpnStatus.disconnected) return;

    _status = VpnStatus.connecting;
    notifyListeners();

    // Simulate connection delay
    await Future.delayed(const Duration(seconds: 2));

    _status = VpnStatus.connected;
    _startTimer();
    notifyListeners();
  }

  void disconnect() {
    _status = VpnStatus.disconnected;
    _stopTimer();
    notifyListeners();
  }

  void _startTimer() {
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final duration = now.difference(_startTime!);
      _formatDuration(duration);
      notifyListeners();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _durationText = "00:00:00";
  }

  void _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    _durationText = "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
