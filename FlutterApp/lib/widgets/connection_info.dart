import 'package:flutter/material.dart';

class ConnectionInfo extends StatelessWidget {
  const ConnectionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: Text(
        'WiFi: Zarifs Car | Pass: 12344321',
        style: TextStyle(
          fontSize: 12,
          color: Colors.white.withOpacity(0.8),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
