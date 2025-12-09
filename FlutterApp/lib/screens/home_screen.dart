import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/car_controller.dart';
import '../widgets/animated_title.dart';
import '../widgets/car_icon.dart';
import '../widgets/status_card.dart';
import '../widgets/mode_switch.dart';
import '../widgets/control_panel.dart';
import '../widgets/connection_info.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0a0e27),
              Color(0xFF1a1f3a),
              Color(0xFF0d1b2a),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                
                // Animated Title
                const AnimatedTitle(),
                
                const SizedBox(height: 20),
                
                // Car Icon with Animation
                const CarIcon(),
                
                const SizedBox(height: 20),
                
                // Status Display
                const StatusCard(),
                
                const SizedBox(height: 20),
                
                // Mode Switch
                const ModeSwitch(),
                
                const SizedBox(height: 30),
                
                // Control Panel
                const ControlPanel(),
                
                const SizedBox(height: 30),
                
                // Connection Info
                const ConnectionInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
