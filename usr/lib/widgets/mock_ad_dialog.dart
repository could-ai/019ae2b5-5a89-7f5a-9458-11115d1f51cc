import 'dart:async';
import 'package:flutter/material.dart';

class MockAdDialog extends StatefulWidget {
  final VoidCallback onAdComplete;

  const MockAdDialog({super.key, required this.onAdComplete});

  @override
  State<MockAdDialog> createState() => _MockAdDialogState();
}

class _MockAdDialogState extends State<MockAdDialog> {
  int _secondsRemaining = 5;
  Timer? _timer;
  bool _canClose = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canClose = true;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Ad Header
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Sponsored Ad", style: TextStyle(color: Colors.grey)),
                  if (_canClose)
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onAdComplete();
                      },
                    )
                  else
                    Text("Reward in $_secondsRemaining", style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            
            // Ad Content Placeholder
            Expanded(
              child: Container(
                color: Colors.black87,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.movie_creation_outlined, size: 60, color: Colors.white54),
                    const SizedBox(height: 20),
                    const Text(
                      "BEST VPN APP EVER!",
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Download Now for Free",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("INSTALL NOW"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
